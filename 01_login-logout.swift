/* Diccionario de usuarios */
var adminUser = "admin" // Unico usuario admin. No se puede crear otro
var usersDict:[String:String] = [adminUser:"adminPwd",
                                 "user":"userPwd"]

/* Variables */
var isAdmin = false // 'true' si usuario autenticado es admin. 'false' todo lo demas
var sessionUser = "" // variable para saber cual usuario esta autenticado
var menuResponse: String

/* Constantes */
let wordCancel = "cancel"
// Numeros de opciones del menu
let optionLogout = "1"
let optionClose = "0"
let optionAdminRegisterUser = "101"


/* Funciones (deben ir primero) */


/*
 *  Funcion simple para limpiar la pantalla de la linea de comandos.
 */
func cleanScreen() {
    print("\u{001B}[2J")
}

/*
 *  Funcion que imprime el menu del usuario.
 *  Lee la respuesta y la regresa en tipo de dato String.
 */
func getMenuResponse() -> String {
    print("\n\n\n")
    print("\tElige una opcion del menu")
    print("\n\t" + optionLogout + ". Cerrar Sesion")
    print("\n\t" + optionClose + ". Salir")
    if isAdmin {
        print("\n\t ----- OPCIONES DE ADMINISTRADOR -----")
        print("\n\t" + optionAdminRegisterUser + ". Registrar nuevo usuario")
    }
    
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
 *  Funcion que revisa si el usuario dado ya esta registrado.
 *  'false' si no esta registrado.
 *  'true' si ya esta registrado.
 */
func isUserRegistered(givenUser: String) -> Bool {
    for (user, _) in usersDict { // Iterar por cada usuario registrado en usersDict
        if givenUser == user {
            return true
        }
    }
    return false
}

/*
 *  Funcion simple para pausar el sistema
 */
func pause() {
    print("\n\nPresione una tecla para continuar")
    let _ = readLine()
}

/*
 *  Funcion que imprime el menu de registro de nuevo usuario y guarda al usuario.
 */
func registerUser() {
    var userExists = true
    
    while userExists {
        cleanScreen()
        print("Escribe '" + wordCancel + "' para volver al menu")
        print("Escribe el usuario a registrar: ")
        let responseUser = readLine()
        if let responseUser = responseUser { // Revisar que no sea nil
            if responseUser == wordCancel { // Si el usuario cancela
                break
            }
            userExists = isUserRegistered(givenUser: responseUser)
            if userExists {
                print("\n\nEl usuario ya existe. Favor de escribir otro")
                pause()
            }
            else {
                print("Escribe la contrasena: ")
                let responsePassword = readLine()
                if let responsePassword = responsePassword {
                    usersDict[responseUser] = responsePassword
                }
            }
        }
    }
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
            print("Bienvenido(a), " + responseUser)
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
    cleanScreen()
    login()
}

menuResponse = getMenuResponse()
while menuResponse != optionClose {
    switch (menuResponse) {
        case optionAdminRegisterUser: // Opcion exclusiva de admin
            if isAdmin {
                registerUser()
                cleanScreen()
            }
            else {
                cleanScreen()
            }
        case optionLogout:
            logout()
            while sessionUser == "" {
                cleanScreen()
                login()
            }
        case optionClose:
            break
        default:
            cleanScreen()
    }
    menuResponse = getMenuResponse()
}
