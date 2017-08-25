
//    const char* accountId = "Ardas test"; // YOUR_ACCOUNT_ID
// const char* accountKey = "287708C2BE7048A3B4D8518D84E642B3"; // YOUR_ACCOUNT_KEY

class Config {
    
    static let sharedInstance = Config()
    
    func getAccountId() -> String {
        return "Ardas test"
    }
    
    func getAccountKey() -> String {
        return "287708C2BE7048A3B4D8518D84E642B3"
    }
    
    func facebookAppId() -> String {
        //return "934526416650007" // yurakrohmal test account
        return "1559271584357436"
    }
    
    func facebookAppDisplayName() -> String {
        return "AllUnite Playground"
    }
    
}
