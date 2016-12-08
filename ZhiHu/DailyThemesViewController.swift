//
//  DailyThemesViewController.swift
//  ZhiHu
//
//  Created by 吴明亮 on 16/4/8.
//  Copyright © 2016年 吴明亮. All rights reserved.
//

import UIKit
import AlamofireImage

class DailyThemesViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate {
    var themeID: Int = 0
    var mainTableView: UITableView!
    var mainScrollView: UIScrollView!
    var imaView: UIImageView!
    var viewmodel: DailyThemesViewModel!
    
    fileprivate let  BNCScreenWidth = UIScreen.main.bounds.size.width
    fileprivate let  BNCScreenHeight = UIScreen.main.bounds.size.height
    
    convenience init() {
        self.init(nibName:nil, bundle:nil)
        themeID = 0
        viewmodel = DailyThemesViewModel.init()

    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)   {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
//    init() {
//        //super.init(nibName: nil, bundle: nil)
//        
//        themeID = 0
//        viewmodel = DailyThemesViewModel.init()
//    }
//    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        viewmodel.removeObserver(self, forKeyPath: "stories")
        viewmodel.removeObserver(self, forKeyPath: "imageURLStr")
        viewmodel.removeObserver(self, forKeyPath: "name")
        viewmodel.removeObserver(self, forKeyPath: "editors")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubViews()
        viewmodel.addObserver(self, forKeyPath: "stories", options: .new, context: nil)
        viewmodel.addObserver(self, forKeyPath: "imageURLStr", options: .new, context: nil)
        viewmodel.addObserver(self, forKeyPath: "name", options: .new, context: nil)
        viewmodel.addObserver(self, forKeyPath: "editors", options: .new, context: nil)
        viewmodel.getDailyThemesDataWithThemeID(themeID)
    }
    
    
    func initSubViews() {
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName:UIFont.boldSystemFont(ofSize: 20),NSForegroundColorAttributeName:UIColor.white]
        self.navigationController?.navigationBar.setBackgroundImage(UIImage.init(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage.init()
        
        mainScrollView = UIScrollView.init(frame: UIScreen.main.bounds)
        self.view.addSubview(mainScrollView)
        
        imaView = UIImageView.init(frame: CGRect(x: 0, y: -24, width: BNCScreenWidth, height: 122 ))
        imaView.contentMode = .scaleAspectFill
        mainScrollView.addSubview(imaView)
        
        mainTableView = UITableView.init(frame: CGRect(x: 0, y: 64, width: BNCScreenWidth, height: BNCScreenHeight - 64))
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.rowHeight = 88
        mainTableView.backgroundColor = UIColor.clear
        self.view.addSubview(mainTableView)
        
        mainTableView.register(HomeViewCell.self, forCellReuseIdentifier: NSStringFromClass(HomeViewCell.self))

        
        let leftBarButton = UIBarButtonItem.init(image: UIImage.init(named: "News_Arrow"), style: .plain, target: self, action: #selector(DailyThemesViewController.back(_:) ))
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        let rightBarButton = UIBarButtonItem.init(image: UIImage.init(named: "Dark_Management_Add"), style: .plain, target: self, action: #selector(DailyThemesViewController.back(_:) ))
        self.navigationItem.rightBarButtonItem = rightBarButton
        
    }
    
    func back(_ sender:UIBarButtonItem ) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func attention(_ sender:UIBarButtonItem ) {
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "stories" {
            mainTableView.reloadData()
        }
        
        if keyPath == "imageURLStr" {
            imaView.af_setImage(withURL: URL.init(string: viewmodel.imageURLStr)!)
            
            
        }
        
        if keyPath == "name" {
            title = viewmodel.name
        }
        
        if keyPath == "editors" {
            if viewmodel.editors.count > 0 {
                let headerView = UIView.init(frame: CGRect(x: 0, y: 0, width: BNCScreenWidth, height: 44))
                headerView.backgroundColor = UIColor.white
                let lab = UILabel.init(frame: CGRect(x: 15, y: 7, width: 40, height: 30))
                lab.text = "主编"
                headerView.addSubview(lab)
                for index in 0...viewmodel.editors.count - 1 {
                    let dic = viewmodel.editors[index]
                    let imaView = UIImageView.init(frame: CGRect( x: CGFloat(65 + 40 * index), y: 7, width: 30, height: 30))
                    imaView.af_setImage(withURL: URL.init(string: dic["avatar"] as! String)!)
                    imaView.layer.cornerRadius = 15
                    imaView.layer.masksToBounds = true
                    headerView.addSubview(imaView)
                }
                mainTableView.tableHeaderView = headerView
            }
        }

    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSetY = scrollView.contentOffset.y
        if -offSetY < 48 && -offSetY > 0 {
            mainScrollView.contentOffset = CGPoint(x: 0, y: offSetY / 2)
        } else if -offSetY > 48 {
            scrollView.contentOffset = CGPoint(x: 0, y: -48)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewmodel.stories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(HomeViewCell.self), for: indexPath) as! HomeViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        let story = viewmodel.stories[indexPath.row]
        cell.updateUIWithStoryModel(story)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = viewmodel.stories[indexPath.row]
        
        var storiesID = [Int]()
        for index in 0...viewmodel.stories.count-1 {
            let id = viewmodel.stories[index].storyID
            storiesID.append(id)
        }
        
        let vm = StoryContentViewModel.init(withCurID: model.storyID, storiesID: storiesID)
        vm.type = model.type
        self.navigationItem.backBarButtonItem = nil
        self.navigationController?.pushViewController(WKWebViewController.init(WithViewModel: vm), animated: true)
        
       
    }
 
}
