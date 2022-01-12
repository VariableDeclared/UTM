//
// Copyright © 2022 osy. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import SwiftUI

@available(iOS 14, macOS 11, *)
struct UTMPendingVMDetailsView: View {
    @ObservedObject var vm: UTMPendingVirtualMachine
    
    private var downloadProgress: String {
        get {
            if let currentSize = vm.downloadedSize, let estimatedSize = vm.estimatedDownloadSize {
                let estimatedSpeed = vm.estimatedDownloadSpeed ?? NSLocalizedString("Extracting…", comment: "Word for decompressing a compressed folder")
                let formatString = NSLocalizedString("%1$@ of %2$@ (%3$@)", comment: "Format string for download progress and speed, e. g. 5 MB of 6 GB (200 kbit/s)")
                return String(format: formatString, currentSize, estimatedSize, estimatedSpeed)
            } else {
                return NSLocalizedString("Preparing…", comment: "A download process is about to begin.")
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .center) {
            Text(downloadProgress)
                .lineLimit(1)
                .padding(.top)
            
            if #available(iOS 15, macOS 12.0, *) {
                Button(role: .cancel, action: vm.cancel) {
                    Label("Cancel Download", systemImage: "xmark.circle")
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
                .disabled(vm.estimatedDownloadSpeed == nil)
                .padding([.bottom, .leading, .trailing])
            } else {
                Button(action: vm.cancel) {
                    Label("Cancel Download", systemImage: "xmark.circle")
                }
                .foregroundColor(.red)
                .disabled(vm.estimatedDownloadSpeed == nil)
                .padding([.bottom, .leading, .trailing])
            }
        }
        .frame(minWidth: 230, maxWidth: .infinity)
    }
}

#if DEBUG
struct UTMPendingVMDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        UTMPendingVMDetailsView(vm: UTMPendingVirtualMachine(name: "My Pending VM"))
    }
}
#endif
