import Foundation

extension Disposable {
    /// Adds `self` to `bag`
    ///
    /// - parameter bag: `DisposeBag` to add `self` to.
    public func disposed(by bag: DisposeBag) {
        bag.insert(self)
    }
}

public class DisposeBag {
    
    // MARK: - PROEPERTIES
    
    fileprivate var _disposables = [Disposable]()
    fileprivate var _isDisposed = false
    
    // MARK: - INITIALIZATION
    
    /// Initialization
    public init() {}
    
    // MARK: - PUBLIC FUNCTIONS
    
    /// Adds `disposable` to be disposed when dispose bag is being deinited.
    ///
    /// - parameter disposable: Disposable to add.
    public func insert(_ disposable: Disposable) {
        self._insert(disposable)?.dispose()
    }
    
    /// This can be called directly or indirectly on deinit
    public func dispose() {
        let oldDisposables = self._dispose()
        for disposable in oldDisposables {
            disposable.dispose()
        }
    }
    
    // MARK: - PRIVATE FUNCTIONS
    
    private func _insert(_ disposable: Disposable) -> Disposable? {
        if self._isDisposed {
            return disposable
        }
        
        self._disposables.append(disposable)
        
        return nil
    }
    
    private func _dispose() -> [Disposable] {
        let disposables = self._disposables
        
        self._disposables.removeAll(keepingCapacity: false)
        self._isDisposed = true
        
        return disposables
    }
    
    deinit {
        self.dispose()
    }
    
}
