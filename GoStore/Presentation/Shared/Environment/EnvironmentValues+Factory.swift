//
//  EnvironmentValues+Factory
//  GoStore - Clean Architecture Sample
//  Created by Zine.
//
//  Adds a ViewModelFactory entry to SwiftUI's EnvironmentValues.
//  This enables dependency injection for SwiftUI views by providing
//  access to the configured ViewModelFactory instance.
//

import SwiftUI

extension EnvironmentValues {
    var viewModelFactory: ViewModelFactory? {
        get { self[ViewModelFactoryKey.self] }
        set { self[ViewModelFactoryKey.self] = newValue }
    }
}


private struct ViewModelFactoryKey: EnvironmentKey {    
    static var defaultValue: ViewModelFactory? = nil
}
