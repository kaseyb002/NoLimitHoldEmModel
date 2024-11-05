import Foundation

extension Array {
    mutating public func updateOrInsert(
        _ element: Element,
        at index: Int = .zero,
        where exists: (Element) -> Bool
    ) {
        if let index: Int = firstIndex(where: exists) {
            self[index] = element
        } else {
            self.insert(element, at: index)
        }
    }
    
    mutating public func updateOrAppend(
        _ element: Element,
        where exists: (Element) -> Bool
    ) {
        if let index: Int = firstIndex(where: exists) {
            self[index] = element
        } else {
            self.append(element)
        }
    }
    
    mutating public func updateIfExists(
        _ element: Element,
        where exists: (Element) -> Bool
    ) {
        if let index: Int = firstIndex(where: exists) {
            self[index] = element
        }
    }
    
    mutating public func mutate(
        _ mutate: (inout Element) -> Void,
        where exists: (Element) -> Bool
    ) {
        guard let index: Int = firstIndex(where: exists) else {
            return
        }
        var element: Element = self[index]
        mutate(&element)
        self[index] = element
    }
    
    public func randomBunch(limit: Int? = nil) -> [Element] {
        guard isEmpty == false else {
            return self
        }
        
        let count: Int =
        if let limit: Int {
            Swift.min(limit, count)
        } else {
            .random(in: 1 ... count)
        }
        
        return Array(self.shuffled().prefix(count))
    }
    
    public func asSet() -> Set<Element> where Element: Hashable {
        Set(self)
    }
}
