//
//  ConnectionSearchView.swift
//  iRail
//
//  Created by Jan Baetens on 20/11/2018.
//  Copyright © 2018 Jan Baetens. All rights reserved.
//
import UIKit

class ConnectionSearchView: UIView {
    @IBOutlet private var contentView:UIView?
    // other outlets
    
    override init(frame: CGRect) { // for using CustomView in code
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("ConnectionSearchView", owner: self, options: nil)
        guard let content = contentView else { return }
        content.frame = self.bounds
        content.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(content)
    }

}
