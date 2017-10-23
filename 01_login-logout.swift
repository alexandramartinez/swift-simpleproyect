/* Diccionario de usuarios */
var adminUser = "admin" // Unico usuario admin. No se puede crear otro
var usersDict:[String:String] = [adminUser:"adminPwd",
                                 "user":"userPwd"]

/* Variables */
var isAdmin = false // 'true' si usuario autenticado es admin. 'false' todo lo demas
var sessionUser = "" // variable para saber cual usuario esta autenticado
var menuResponse: String


/* Funciones (deben ir primero) */

/*
 *  Funcion que imprime el menu del usuario.
 *  Lee la respuesta y la regresa en tipo de dato String.
 */
func getMenuResponse() -> String {
    print("\n\n\n")
    print("\tElige una opcion del menu")
    print("\n\t1. Cerrar Sesion")
    print("\n\t0. Salir")
    print("\t")
    
    let menuResponse = readLine()
    
    if let menuResponse = menuResponse {
        return menuResponse
    }
    else {
        return ""
    }
}

/*
 *  Funcion que cierra la sesion del usuario actual
 */
func logout() {
    sessionUser = ""
    isAdmin = false
}

/*
 *   Funcion que simula la pantalla de login para el usuario.
 *   Lee el usuario y contrasena, e imprime si se pudo autenticar o no.
 *   Modifica la variable global 'isAdmin' dependiendo de la autenticacion.
 *   Modifica la variable 'sessionUser' para saber cual usuario esta autenticado.
 */
func login() {
    
    print("Escribe tu usuario: ")
    let responseUser = readLine()
    
    print("Escribe tu contrasena: ")
    let responsePassword = readLine()
    
    if let responseUser = responseUser { // Revisar que usuario no sea nil
        // Iniciar autenticacion
        if isAutenticated(givenUser: responseUser, givenPassword: responsePassword!) {
            print("Bienvenido, " + responseUser)
            sessionUser = responseUser
            if responseUser == adminUser {
                isAdmin = true
            }
            else {
                isAdmin = false
            }
        }
        else { // Si no se encuentra el usuario y/o la contrasena esta equivocada
            sessionUser = ""
            isAdmin = false
        }
    }
    else { // Si el valor de usuario es nil
        sessionUser = ""
        isAdmin = false
    }
}

/*
 *   Funcion que regresa un valor booleano si el usuario existe en el diccionario
 *   de usuarios o no, y si la contrasena es correcta o no.
 *   'true' si el usuario existe y la contrasena es correcta.
 *   'false' si el usuario no existe y/o la contrasena es incorrecta.
 */
func isAutenticated(givenUser: String, givenPassword: String) -> Bool {
    for (user, password) in usersDict { // Iterar por cada usuario registrado en usersDict
        if givenUser == user {
            if givenPassword == password {
                return true
            }
            else {
                return false
            }
        }
    }
    return false // Regresar false si no se encontro el usuario en el diccionario
}
    /**************************/
    /**************************/
    /********** MAIN **********/
    /**************************/
    /**************************/
while sessionUser == "" {
    print("\u{001B}[2J") // Limpiar pantalla de comandos
    login()
}

menuResponse = getMenuResponse()
while menuResponse != "0" {
    switch (menuResponse) {
        case "1":
            logout()
            while sessionUser == "" {
                print("\u{001B}[2J") // Limpiar pantalla de comandos
                login()
            }
        case "0":
            break
        default:
            menuResponse = ""
            print("\u{001B}[2J") // Limpiar pantalla de comandos
    }
    menuResponse = getMenuResponse()
}
