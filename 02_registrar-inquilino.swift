/* Diccionarios (simula una base de datos)*/
var adminUser = "admin" // Unico usuario admin. No se puede crear otro
var usersDict:[String:String] = [adminUser:"adminPwd", // usuario : contraseña
                                "user":"userPwd",
                                "ana":"ana",
                                "jorge":"jorge",
                                "juan":"juan",
                                "maria":"maria"]
var usuario_inquilinoDict:[String:Int] = ["user":1, // usuario : id de inquilino
                                          "ana":2,
                                          "jorge":3,
                                          "juan":4,
                                          "maria":5]
var inquilinosNombresDict:[Int:String] = [1:"Usuario", // id : nombre de inquilino
                                          2:"Ana Medina",
                                          3:"Jorge A.",
                                          4:"Juan Perez",
                                          5:"Maria Rodriguez"]
var inquilinosTelefonosDict:[Int:String] = [1:"12345678", // id : telefono de inquilino
                                            2:"37849589",
                                            3:"23434556",
                                            4:"90905783",
                                            5:"46475892"]
var inquilinosCorreosDict:[Int:String] = [1:"usuario@correo.com", // id : correo de inquilino
                                          2:"ana.medina@correo.com",
                                          3:"jorge.a@correo.com",
                                          4:"juan.perez@correo.com",
                                          5:"maria.rdz@correo.com"]
var departamento_inquilinoDict:[String:Int] = ["1":1,  // numero de departamento : id de inquilino
                                               "2":2,
                                               "3":3,
                                               "4":4,
                                               "5":5]
var usuario_activoDict:[Int:Bool] = [1:true, // id : activo/inactivo
                                     2:true,
                                     3:true,
                                     4:true,
                                     5:true]

/* Variables */
var isAdmin = false // 'true' si usuario autenticado es admin. 'false' todo lo demas
var sessionUser = "" // variable para saber cual usuario esta autenticado
var menuResponse: String
var nextUserId = 6; // para empezar a crear nuevos usuarios

/* Constantes */
let wordCancel = "cancel"
// Numeros de opciones del menu
let optionLogout = "1"
let optionClose = "0"
let optionAdminRegisterUser = "101"


/* Funciones (deben ir primero) */


/**
 *  Funcion simple para limpiar la pantalla de la linea de comandos.
 */
func cleanScreen() {
    print("\u{001B}[2J")
}

/**
 *  Funcion que cierra la sesion del usuario actual
 */
func logout() {
    sessionUser = ""
    isAdmin = false
}

/**
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

/**
 *  Funcion simple para pausar el sistema
 */
func pause() {
    print("\n\nPresione una tecla para continuar")
    let _ = readLine()
}

/**
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
                if saveNewUserInfo(givenUser: responseUser) {
                    print("\n\nEl usuario se guardo con exito")
                    pause()
                }
            }
        }
    }
}

/**
 *  Funcion que realiza el guardado del usuario.
 *  Regresa 'true' para indicar que se guardo correctamente o 'false' si no se realizo la operacion.
 *  Toma como parametro el nombre de usuario que se va a guardar.
 */
func saveNewUserInfo(givenUser: String) -> Bool {
    var pedirDepartamentoDeNuevo = true
    
    print("\nEscribe la contrasena: ")
    let responsePassword = readLine()
    if let responsePassword = responsePassword {
        
        if responsePassword == wordCancel { // Si el usuario cancela
            return false
        }
        
        print("\nEscribe el nombre del inquilino: ")
        let responseName = readLine()
        if let responseName = responseName {
            
            if responseName == wordCancel { // Si el usuario cancela
                return false
            }
            
            print("\nEscribe el telefono del inquilino: ")
            let responsePhone = readLine()
            if let responsePhone = responsePhone {
                
                if responsePhone == wordCancel { // Si el usuario cancela
                    return false
                }
                
                print("\nEscribe el correo del inquilino: ")
                let responseMail = readLine()
                if let responseMail = responseMail {
                    
                    if responseMail == wordCancel { // Si el usuario cancela
                        return false
                    }
                    
                    while (pedirDepartamentoDeNuevo) {
                        print("\nEscribe el numero del departamento del inquilino: ")
                        let responseApt = readLine()
                        if let responseApt = responseApt {
                            
                            if responseApt == wordCancel { // Si el usuario cancela
                                return false
                            }
                            
                            let activeUserId = getActiveUserId(givenApt: responseApt)
                            if activeUserId != -1 { // si ya hay un inquilino activo para este apt
                                print("\n\nYa hay un inquilino activo en el departamento " + responseApt + ": " + inquilinosNombresDict[activeUserId]!)
                                print("Seleccione una opcion:")
                                print("\t1. Usar el nuevo inquilino para este departamento")
                                print("\t2. Ingresar otro numero de departamento")
                                print("\t3. Cancelar la alta de usuario")
                                let response = readLine()
                                if let response = response {
                                    switch (response) {
                                    case "1":
                                        // guardar nuevo inquilino
                                        usersDict[givenUser] = responsePassword
                                        usuario_inquilinoDict[givenUser] = nextUserId
                                        inquilinosNombresDict[nextUserId] = responseName
                                        inquilinosTelefonosDict[nextUserId] = responsePhone
                                        inquilinosCorreosDict[nextUserId] = responseMail
                                        departamento_inquilinoDict[responseApt] = nextUserId
                                        usuario_activoDict[nextUserId] = true
                                        // actualizar contador de ids
                                        nextUserId += 1
                                        // salir del loop del departamento
                                        pedirDepartamentoDeNuevo = false
                                        // desactivar antiguo inquilino
                                        usuario_activoDict[activeUserId] = false
                                        
                                        return true
                                    case "2":
                                        continue
                                    case "3":
                                        return false
                                    default:
                                        pedirDepartamentoDeNuevo = false
                                    }
                                }
                            }
                            else {
                                // guardar nuevo inquilino
                                usersDict[givenUser] = responsePassword
                                usuario_inquilinoDict[givenUser] = nextUserId
                                inquilinosNombresDict[nextUserId] = responseName
                                inquilinosTelefonosDict[nextUserId] = responsePhone
                                inquilinosCorreosDict[nextUserId] = responseMail
                                departamento_inquilinoDict[responseApt] = nextUserId
                                usuario_activoDict[nextUserId] = true
                                // actualizar contador de ids
                                nextUserId += 1
                                // salir del loop del departamento
                                pedirDepartamentoDeNuevo = false
                                // desactivar antiguo inquilino
                                usuario_activoDict[activeUserId] = false
                                
                                return true
                            }
                        }
                    }
                }
            }
        }
    }
    return false
}

/**
 *  Funcion que regresa el ID del inquilino activo en un departamento.
 *  Toma como parametro el departamento.
 *  Regresa un -1 si no encontro un inquilino activo o un departamento que coincida.
 */
func getActiveUserId(givenApt: String) -> Int {
    for (apt, userId) in departamento_inquilinoDict {
        if apt == givenApt {
            for (id, active) in usuario_activoDict {
                if id == userId {
                    if active {
                        return id
                    }
                    else {
                        return -1
                    }
                }
            }
        }
    }
    return -1
}

/**
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

/**
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

/**
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
        print("\n\t" + optionAdminRegisterUser + ". Registrar nuevo inquilino")
    }
    
    let menuResponse = readLine()
    
    if let menuResponse = menuResponse {
        return menuResponse
    }
    else {
        return ""
    }
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
