
import Foundation

class FAQ {
    var question: String
    var answers: [Answer]
    
    var rowCount: Int {
        return answers.count
    }
    
    var isCollapsed = true
    
    init(question: String, answers: [Answer]) {
        self.question = question
        self.answers = answers
    }
}
