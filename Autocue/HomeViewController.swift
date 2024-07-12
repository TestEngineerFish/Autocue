import UIKit

class HomeViewController: AtViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    enum EditType {
        case normal, edit
    }
    
    @IBOutlet weak var leftItem: UIBarButtonItem!
    @IBOutlet weak var rightItem: UIBarButtonItem!
    
    private var modelList = [BPCueModel]()
    private var selectedList: Set<Int> = []
    
    private var editType: EditType = .normal {
        willSet {
            switch newValue {
            case .normal:
                leftItem.title = "编辑"
                rightItem.title = "添加"
            case .edit:
                leftItem.title = "取消"
                rightItem.title = "删除"
            }
            collectionView.reloadData()
        }
    }
    private var selectedModelList = [BPCueModel]()
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.reloadData()
    }
    
    @IBAction func leftAction(_ sender: UIBarButtonItem) {
        switch editType {
        case .normal:
            editType = .edit
        case .edit:
            editType = .normal
            selectedList.removeAll()
        }
    }
    
    @IBAction func rightAction(_ sender: UIBarButtonItem) {
        switch editType {
        case .normal:
            pushEditVC(model: nil)
        case .edit:
            var items = [IndexPath]()
            selectedList.forEach { index in
                if index < modelList.count {
                    let model = modelList[index]
//                    BPIMDBOperator.default.deleteCue(id: model.id)
                    items.append(IndexPath(row: index, section: 0))
                }
            }
            self.collectionView.performBatchUpdates {
                self.collectionView.deleteItems(at: items)
            }
//            reloadData()
            editType = .normal
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        self.initData()
        self.reloadData()
        // Do any additional setup after loading the view.
        
//        let playButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
//        playButton.setTitle("播放视频", for: .normal)
//        playButton.setTitleColor(.blue, for: .normal)
//        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
//        playButton.center = view.center
//        view.addSubview(playButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
//    @objc func playButtonTapped() {
//        let text = "这是一个示例文本"
//        let duration: TimeInterval = 10
//
//        composeVideoWithText(text: text, duration: duration)
//    }
    
    // MARK: ==== Init ====
    private func initUI() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection          = .vertical
        layout.minimumLineSpacing       = 10
        layout.minimumInteritemSpacing  = 15
        let contentInset    = UIEdgeInsets(top: 30, left: 10, bottom: 30, right: 10)
        let size            = CGSize(width: (collectionView.bounds.width - contentInset.left - contentInset.right - layout.minimumInteritemSpacing)/2, height: 200)
        layout.itemSize                     = size
        collectionView.collectionViewLayout = layout
        collectionView.contentInset         = contentInset
    }
    private func initData() {
        collectionView.register(HomeCollectionCell.classForCoder(), forCellWithReuseIdentifier: "HomeCollectionCell")
    }
    
    // MARK: ==== Event ====
    private func reloadData() {
        self.modelList = BPIMDBOperator.default.selectAllCue()
        collectionView.reloadData()
    }
    
    private func pushEditVC(model: BPCueModel?) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let editViewController = storyboard.instantiateViewController(withIdentifier: "EditViewController") as? EditViewController {
            if let _model = model {
                editViewController.model = _model
            }
            self.navigationController?.pushViewController(editViewController, animated: true)
        }
    }
    
    // MARK: ==== Delegate、DataSource ====
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return modelList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionCell", for: indexPath) as? HomeCollectionCell else {
            return UICollectionViewCell()
        }
        let model = modelList[indexPath.row]
        cell.setData(model: model, isSelected: selectedList.contains(indexPath.row))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch editType {
        case .normal:
            pushEditVC(model: modelList[indexPath.row])
        case .edit:
            if selectedList.contains(indexPath.row) {
                selectedList.remove(indexPath.row)
            } else {
                selectedList.insert(indexPath.row)
            }
            collectionView.reloadItems(at: [indexPath])
        }
    }
}
