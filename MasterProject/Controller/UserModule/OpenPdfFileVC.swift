//
//  OpenPdfFileVC.swift
//  Tiller
//
//  Created by Dhaval Bhadania on 30/08/17.
//  Copyright © 2017 Sanjay Shah. All rights reserved.
//

import UIKit

class OpenPdfFileVC: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var labelTitle: UILabel!

    var strFileName: String!
    var strTitle: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.removeMenu()
        labelTitle.text = strTitle
        strFileName = "TermsAndCondition";
        
        if let pdfURL = Bundle.main.path(forResource: "\(strFileName!)", ofType: "pdf") {
            webView.loadRequest(URLRequest(url: URL(string: pdfURL)!))
            webView.allowsLinkPreview = true
            webView.scrollView.decelerationRate = UIScrollViewDecelerationRateFast
        }

        // Do any additional setup after loading the view.
    }
    
    @IBAction override func goBack(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true);
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
