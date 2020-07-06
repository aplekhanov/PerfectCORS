import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import PerfectSession

private func apiRoutes() -> Routes {
    var routes = Routes()
    return routes
}

private func frontendRoutes() -> Routes {
    var routes = Routes()
    return routes
}


do {
    try HTTPServer.launch(
        .server(name: "apiServer", port: 8000, routes: apiRoutes()),
        .server(name: "frontend", port: 8080, routes: frontendRoutes())
    )
} catch PerfectError.networkError(let err, let msg) {
    print("Network error thrown: \(err) \(msg)")
}
