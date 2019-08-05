import UIKit
import Firebase

class CreatePostVC: UIViewController {

    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var messageContent: UITextView!
    @IBOutlet weak var sendButtonView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView(){
        messageContent.delegate = self
        sendButtonView.bindToKeyboard()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        userEmail.text = Auth.auth().currentUser?.email
    }
    
    @IBAction func sendPressed(_ sender: Any) {
        prepareToSendMessage()
    }
    
    private func prepareToSendMessage(){
        guard let message = messageContent.text , messageContent.text != "" , messageContent.text != "Say something here ..." else {
            view.endEditing(true)
            return
        }
        self.sendButton.isEnabled = false
        sendMessageData(message: message)
    }
    
    private func sendMessageData(message:String){
        guard let userId = Auth.auth().currentUser?.uid else { return }
        DataService.instance.uploadNewPost(message: message, userID: userId, groupKey: nil) { (Success) in
            if Success {
                self.dismissDetails()
            }
            self.sendButton.isEnabled = true
        }
    }
    
    @IBAction func backPressed(_ sender: Any) {
        dismissDetails()
    }
}

extension CreatePostVC: UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        messageContent.text = ""
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            prepareToSendMessage()
            return false
        }
        return true
    }
}
