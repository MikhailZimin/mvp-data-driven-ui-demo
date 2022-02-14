import UIKit

extension UIView {
    func addAnimation(keyPath: String, duration: Double = 0.25, onComplete: (() -> Void)? = nil) {
        let animation = CABasicAnimation(keyPath: keyPath)
        animation.duration = duration

        if let onComplete = onComplete {
            animation.delegate = AnimationDelegate { _, completed in
                guard completed else { return }

                onComplete()
            }
        }

        layer.add(animation, forKey: keyPath)
    }
}

final class AnimationDelegate: NSObject, CAAnimationDelegate {
    let didStop: ((CAAnimation, Bool) -> Void)?

    init(didStop: ((CAAnimation, Bool) -> Void)? = nil) {
        self.didStop = didStop
    }

    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.didStop?(anim, flag)
    }
}
