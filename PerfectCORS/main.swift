import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import PerfectSession


SessionConfig.CORS.enabled = true
SessionConfig.CORS.acceptableHostnames = ["*"]
SessionConfig.CORS.methods = [.get, .post, .options]

let sessionDriver = SessionMemoryDriver()

private func apiRoutes() -> Routes {
    var routes = Routes()
    routes.add(method: .get, uri: "/get") { request, response in
        let json = try! ["name": "John Appleseed"].jsonEncodedString()
        try! response.setHeader(.contentType, value: "application/json")
            .setBody(json: json)
            .completed()
    }
    routes.add(method: .post, uri: "/post") { request, response in
        let json = request.postBodyString
        try! response.setHeader(.contentType, value: "application/json")
            .setBody(json: json)
            .completed()
    }
    return routes
}

private func frontendRoutes() -> Routes {
    var routes = Routes()
    routes.add(method: .get, uri: "/**", handler: StaticFileHandler(documentRoot: "./webroot").handleRequest)
    return routes
}


do {
    try HTTPServer.launch(
        .server(name: "apiServer", port: 8000, routes: apiRoutes(), requestFilters: [sessionDriver.requestFilter]),
        .server(name: "frontend", port: 8080, routes: frontendRoutes())
    )
} catch PerfectError.networkError(let err, let msg) {
    print("Network error thrown: \(err) \(msg)")
}
