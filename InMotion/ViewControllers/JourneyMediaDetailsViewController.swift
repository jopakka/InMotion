//
//  JourneyMediaDetailsViewController.swift
//  InMotion
//
//  Created by iosdev on 17.4.2021.
//

import UIKit

class JourneyMediaDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    var cellImage: UIImage?
    var longText = """
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur finibus vestibulum laoreet. Morbi ut odio tristique, placerat nulla eget, pharetra orci. Etiam convallis, augue vel tempor tempor, sapien urna ornare augue, eu cursus sem risus vitae turpis. Maecenas non ultricies lectus. Cras ut odio id dui aliquet ultricies. Praesent fermentum ut erat eget mollis. Donec eget orci sollicitudin, dictum augue a, venenatis augue. Nullam finibus vitae diam nec aliquam. Suspendisse pharetra a nisl malesuada cursus. Maecenas fringilla nisi tempus ornare pellentesque.
    
    Donec pretium aliquam felis ut vehicula. Nulla tristique, urna eu porttitor congue, purus eros condimentum tellus, in condimentum lectus sem at metus. Integer iaculis volutpat mi. Etiam urna diam, finibus nec aliquet vitae, lacinia sit amet tellus. Aenean volutpat mauris condimentum lacus tincidunt, a fermentum elit ultricies. Proin eu finibus nisl. Nullam venenatis, augue a tristique vehicula, augue lacus laoreet magna, id commodo ex erat sit amet augue. Morbi dapibus faucibus risus, id convallis odio mattis vel. Sed sollicitudin et eros at semper. In tincidunt, arcu fermentum ultrices fermentum, tortor elit sodales mi, sit amet interdum orci magna in nisl.

    Sed scelerisque lobortis ligula non ultrices. Donec ultrices condimentum metus, lacinia eleifend dolor egestas a. Vivamus fermentum accumsan leo non volutpat. Morbi cursus enim arcu, ac facilisis lorem ornare a. Morbi justo lorem, hendrerit at laoreet ut, ornare eget felis. Pellentesque sit amet cursus tortor. Proin mattis vitae nisl eu rhoncus. Aenean in velit tincidunt, pretium ligula id, laoreet ex. Suspendisse ante massa, mollis sed erat vel, molestie volutpat orci. Ut facilisis ultrices sapien at aliquet.
"""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(MediaDetailsTableViewCell.nib(), forCellReuseIdentifier: MediaDetailsTableViewCell.identifier)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MediaDetailsTableViewCell.identifier, for: indexPath) as! MediaDetailsTableViewCell
        
        cell.configure(image: cellImage!, title: "What a great spot!", description: longText)
        return cell
    }

}
