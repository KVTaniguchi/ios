// Dono iOS - Password Derivation Tool
// Copyright (C) 2016  Dono - Password Derivation Tool
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

import PDFReader
import UIKit

class HowItWorksTableViewCell : UITableViewCell
{
    private static var DonoUrl = "dono"
    
    private static var PdfExtension = "pdf"
    
    override func setSelected(selected: Bool, animated: Bool)
    {
        if (selected)
        {
            self.openPrivacyPolicyUrl()
        }
    }
    
    internal func openPrivacyPolicyUrl()
    {
        let documentURL = NSBundle.mainBundle().URLForResource(HowItWorksTableViewCell.DonoUrl, withExtension: HowItWorksTableViewCell.PdfExtension)!
        let document = PDFDocument(fileURL: documentURL)
        
        let storyboard = UIStoryboard(name: "PDFReader", bundle: NSBundle(forClass: PDFViewController.self))
        let controller = storyboard.instantiateInitialViewController() as! PDFViewController
        controller.document = document
        controller.title = document.fileName
        
        self.viewController()!.navigationController?.pushViewController(controller, animated: true)
    }
}
