import SwiftUI
import WatchConnectivity

class PhoneHeadingReceiver: NSObject, ObservableObject, WCSessionDelegate {
    static let shared = PhoneHeadingReceiver()
    
    @Published var heading: Double = 0
    
    override init() {
        super.init()
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }
    
    // iPhone에서 데이터를 수신하는 메서드
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let heading = message["heading"] as? Double {
            DispatchQueue.main.async {
                self.heading = heading
            }
        }
    }
    
    // 필수 메서드: WCSession이 활성화되면 호출
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("WCSession activation failed with error: \(error.localizedDescription)")
        } else {
            print("WCSession activated with state: \(activationState.rawValue)")
        }
    }
    
    // 선택 사항: iPhone 연결 상태가 변경될 때 호출 (필수는 아님)
    func sessionReachabilityDidChange(_ session: WCSession) {
        print("Session reachability changed: \(session.isReachable)")
    }
}
