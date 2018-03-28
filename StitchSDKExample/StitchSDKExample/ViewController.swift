import UIKit
import StitchCore_iOS
import ExtendedJSON

class ViewController: UIViewController {
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLoginStatusUILabel()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateLoginStatusUILabel() {
        switch stitchClient.auth.isLoggedIn {
        case true:
            statusLabel.text = stitchClient.auth.currentUser?.id
        case false:
            statusLabel.text = "Not logged in."
        }
    }

    private lazy var stitchClient: StitchAppClient = try! Stitch.getDefaultAppClient()
    
    @IBAction func functionOnePressed(_ sender: Any) {
        self.stitchClient.callFunction(withName: "getBool", withArgs: []) { (value, error) in
            print("Bool: \(value as! Bool), Error: \(error)")
        }
    }
    
    
    @IBAction func functionTwoPressed(_ sender: Any) {
        self.stitchClient.callFunction(withName: "getObject", withArgs: []) { (value, error) in
            print("Object: \(value), Error: \(error)")
        }
    }
    
    @IBAction func functionThreePressed(_ sender: Any) {
        self.stitchClient.callFunction(withName: "getNumber", withArgs: []) { (value, error) in
            print("Number: \(value), Error: \(error)")
        }
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        
        let anonAuthClient =
            stitchClient.auth.providerClient(forProvider: AnonymousAuthProvider.clientProvider)
        
        print(UIDevice.current.systemName)
        
        stitchClient.auth.login(withCredential: anonAuthClient.credential) { user, error in
            if let error = error {
                print("Failed to log in: \(error)")
            } else if let user = user {
                
                print("Logged in as user \(user.id)")
                DispatchQueue.main.async {
                    self.updateLoginStatusUILabel()
                }
            }
        }
    }
}
