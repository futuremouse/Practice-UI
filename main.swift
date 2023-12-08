//
//  main.swift
//  baseBall
//
//  Created by t2023-m0024 on 12/8/23.
//




import Foundation

var gameRecords: [Int] = []

func generateRandomAnswer() -> String {
    var digits = Array((0...9).shuffled().prefix(3))
    while digits.first == 0 {
        digits = Array((0...9).shuffled().prefix(3))
    }
    let answer = digits.map { String($0) }.joined()
    return answer
}

func validateUserInput(_ input: String) -> Bool {
    
    guard let _ = Int(input),
          input.count == 3,
          input.first != "0",
            Set(input).count == 3,
          !input.contains("00") else {
    return false
     }
    
     return true
    
 }

func calculatesStrikeAndBall(userInput: String, answer: String) -> String {
    var strikes = 0
    var balls = 0
    var usedUserIndexes: Set<Int> = Set()
    var usedAnswerIndexes: Set<Int> = Set()

    for (index, userDigit) in userInput.enumerated() {
        for (answerIndex, answerDigit) in answer.enumerated() {
            if !usedUserIndexes.contains(index) && !usedAnswerIndexes.contains(answerIndex) && userDigit == answerDigit {
                if index == answerIndex {
                    strikes += 1
                } else {
                    balls += 1
                }
                usedUserIndexes.insert(index)
                usedAnswerIndexes.insert(answerIndex)
                break
            }
        }
    }
    
    var resultString = ""

    if strikes == 0 {
        resultString = "\(strikes)스트라이크" }
    if strikes == 1 {
        resultString = "\(strikes)스트라이크" }
    if strikes == 2 {
        resultString = "\(strikes)스트라이크" }
    if strikes == 3 {
        resultString = "정답입니다!" }


    if balls > 0 {
        if !resultString.isEmpty {
            resultString += " "
        }
        resultString += "\(balls)볼"
    }

    if resultString.isEmpty {
        resultString = "Nothing"
    }

    return resultString
}

func playGame() {
    let answer = generateRandomAnswer()
    print(answer)

    var attempts: Int = 0

    repeat {
        print("숫자를 입력하세요: ", terminator: "")
        if let userInput = readLine(), validateUserInput(userInput) {
            attempts += 1
            let result = calculatesStrikeAndBall(userInput: userInput, answer: answer)
            print(result)
            if result.hasPrefix("정답입니다") {
                gameRecords.append(attempts) // 기록 추가
                return
            } else {
                print("올바른 입력이 아닙니다. 세 자리 숫자를 다시 입력해주세요.")
            }
        } else {
            print("숫자를 입력하세요.")
        }
    } while true
}

    
    func viewRecords(_ records: [Int]) {
        print("<게임 기록 보기>")
        if records.isEmpty {
            print("게임 기록이 없습니다.")
        } else {
            for (index, record) in records.enumerated() {
                print("\(index + 1)번째 게임: 시도 횟수 - \(record)")
            }
        }
    }
    
    print("환영합니다! 원하시는 번호를 입력해주세요")
    repeat {
        print("1. 게임 시작하기 2. 게임 기록 보기 3. 종료하기: ", terminator: "")
        if let choice = readLine(), let menuChoice = Int(choice) {
            switch menuChoice {
            case 1:
                print("<게임을 시작합니다>")
                playGame()
            case 2:
                viewRecords(gameRecords)
            case 3:
                print("<숫자 야구 게임을 종료합니다>")
                exit(0)
            default:
                print("올바르지 않은 입력값입니다")
            }
        } else {
            print("숫자를 입력하세요.")
        }
    } while true
