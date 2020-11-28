//
//  ItemListViewController.swift
//  ToDoApp
//
//  Created by yuji nakamoto on 2020/11/25.
//

import UIKit
import GoogleMobileAds
import EmptyDataSet_Swift
import RealmSwift

class ItemListViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var plusImageView: UIImageView!
    @IBOutlet weak var memoTextField: UITextField!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var viewBottomConst: NSLayoutConstraint!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    
    private var items = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupTextField()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchItem()
    }
    
    // MARK: - Actions
    
    @objc func tapPlusImageView() {
        UserDefaults.standard.removeObject(forKey: CLOSE)
        UserDefaults.standard.set(true, forKey: BACK)
        navigationController?.popViewController(animated: false)
    }
    
    @IBAction func createButtonTapped(_ sender: Any) {
        guard memoTextField.text != "" else { return }
        
        Memo.createMemo(text: memoTextField.text!) { [self] in
            memoTextField.text = ""
            UserDefaults.standard.removeObject(forKey: CLOSE)
            UserDefaults.standard.set(true, forKey: BACK)
            navigationController?.popViewController(animated: false)
        }
    }
    
    // MARK: - Fetch
    
    private func fetchItem() {
        
        let realm = try! Realm()
        let toKatakana = memoTextField.text!.applyingTransform(.hiraganaToKatakana, reverse: false)
        let toHiragana = memoTextField.text!.applyingTransform(.hiraganaToKatakana, reverse: true)
        let itemArray1 = realm.objects(Item.self).filter("name BEGINSWITH '\(toKatakana ?? "")'")
        let itemArray2 = realm.objects(Item.self).filter("name BEGINSWITH '\(toHiragana ?? "")'")
        items.removeAll()

        if memoTextField.text?.prefix(1) == "あ"{
            let a2 = realm.objects(Item.self).filter("name BEGINSWITH '甘'")
            let a3 = realm.objects(Item.self).filter("name BEGINSWITH '揚'")
            let a4 = realm.objects(Item.self).filter("name BEGINSWITH '鯵'")
            items.append(contentsOf: a2)
            items.append(contentsOf: a3)
            items.append(contentsOf: a4)
        }
        if memoTextField.text?.prefix(1) == "い"{
            let i1 = realm.objects(Item.self).filter("name BEGINSWITH '糸'")
            let i2 = realm.objects(Item.self).filter("name BEGINSWITH '芋'")
            let i3 = realm.objects(Item.self).filter("name BEGINSWITH '鰯'")
            let i4 = realm.objects(Item.self).filter("name BEGINSWITH '胃薬'")
            let i5 = realm.objects(Item.self).filter("name BEGINSWITH '痛み'")
            items.append(contentsOf: i1)
            items.append(contentsOf: i2)
            items.append(contentsOf: i3)
            items.append(contentsOf: i4)
            items.append(contentsOf: i5)
        }
        if memoTextField.text?.prefix(1) == "う"{
            let u1 = realm.objects(Item.self).filter("name BEGINSWITH '烏'")
            let u2 = realm.objects(Item.self).filter("name BEGINSWITH '梅'")
            items.append(contentsOf: u1)
            items.append(contentsOf: u2)
        }
        if memoTextField.text?.prefix(1) == "え"{
            let e1 = realm.objects(Item.self).filter("name BEGINSWITH '海老'")
            let e2 = realm.objects(Item.self).filter("name BEGINSWITH '枝'")
            items.append(contentsOf: e1)
            items.append(contentsOf: e2)
        }
        if memoTextField.text?.prefix(1) == "お"{
            let o1 = realm.objects(Item.self).filter("name BEGINSWITH '温'")
            items.append(contentsOf: o1)
        }
        if memoTextField.text?.prefix(1) == "か"{
            let ka2 = realm.objects(Item.self).filter("name BEGINSWITH '海鮮'")
            let ka3 = realm.objects(Item.self).filter("name BEGINSWITH '唐揚げ'")
            let ka4 = realm.objects(Item.self).filter("name BEGINSWITH '数'")
            let ka5 = realm.objects(Item.self).filter("name BEGINSWITH '片'")
            let ka6 = realm.objects(Item.self).filter("name BEGINSWITH '辛'")

            items.append(contentsOf: ka2)
            items.append(contentsOf: ka3)
            items.append(contentsOf: ka4)
            items.append(contentsOf: ka5)
            items.append(contentsOf: ka6)
        }
        if memoTextField.text?.prefix(1) == "き"{
            let ki1 = realm.objects(Item.self).filter("name BEGINSWITH '絹ごし'")
            items.append(contentsOf: ki1)
        }
        if memoTextField.text?.prefix(1) == "け"{
            let ke1 = realm.objects(Item.self).filter("name BEGINSWITH '化粧'")
            items.append(contentsOf: ke1)
            let ke2 = realm.objects(Item.self).filter("name BEGINSWITH '消しゴム'")
            items.append(contentsOf: ke2)
        }
        if memoTextField.text?.prefix(1) == "こ"{
            let ko1 = realm.objects(Item.self).filter("name BEGINSWITH '小麦'")
            let ko2 = realm.objects(Item.self).filter("name BEGINSWITH '高野'")
            let ko3 = realm.objects(Item.self).filter("name BEGINSWITH '濃口'")

            items.append(contentsOf: ko1)
            items.append(contentsOf: ko2)
            items.append(contentsOf: ko3)
        }
        if memoTextField.text?.prefix(1) == "さ"{
            let sa1 = realm.objects(Item.self).filter("name BEGINSWITH '皿'")
            items.append(contentsOf: sa1)
            let sa2 = realm.objects(Item.self).filter("name BEGINSWITH '砂糖'")
            items.append(contentsOf: sa2)
            let sa3 = realm.objects(Item.self).filter("name BEGINSWITH '刺身'")
            items.append(contentsOf: sa3)
        }
        if memoTextField.text?.prefix(1) == "し"{
            let si1 = realm.objects(Item.self).filter("name BEGINSWITH '椎茸'")
            let si2 = realm.objects(Item.self).filter("name BEGINSWITH '生姜'")
            let si3 = realm.objects(Item.self).filter("name BEGINSWITH '食'")
            let si4 = realm.objects(Item.self).filter("name BEGINSWITH '醤油'")
            let si5 = realm.objects(Item.self).filter("name BEGINSWITH '塩'")
            let si6 = realm.objects(Item.self).filter("name BEGINSWITH '焼酎'")
            let si7 = realm.objects(Item.self).filter("name BEGINSWITH 'C'")
            let si8 = realm.objects(Item.self).filter("name BEGINSWITH '消臭'")

            items.append(contentsOf: si1)
            items.append(contentsOf: si2)
            items.append(contentsOf: si3)
            items.append(contentsOf: si4)
            items.append(contentsOf: si5)
            items.append(contentsOf: si6)
            items.append(contentsOf: si7)
            items.append(contentsOf: si8)
        }
        if memoTextField.text?.prefix(1) == "せ"{
            let se1 = realm.objects(Item.self).filter("name BEGINSWITH '洗剤'")
            items.append(contentsOf: se1)
            let se2 = realm.objects(Item.self).filter("name BEGINSWITH '接着'")
            items.append(contentsOf: se2)
        }
        if memoTextField.text?.prefix(1) == "c"{
            let c1 = realm.objects(Item.self).filter("name BEGINSWITH 'C'")
            items.append(contentsOf: c1)
        }
        if memoTextField.text?.prefix(1) == "そ"{
            let so1 = realm.objects(Item.self).filter("name BEGINSWITH '素麺'")
            let so2 = realm.objects(Item.self).filter("name BEGINSWITH '惣菜'")
            let so3 = realm.objects(Item.self).filter("name BEGINSWITH '蕎麦'")
            items.append(contentsOf: so1)
            items.append(contentsOf: so2)
            items.append(contentsOf: so3)
        }
        if memoTextField.text?.prefix(1) == "た"{
            let ta1 = realm.objects(Item.self).filter("name BEGINSWITH '玉ねぎ'")
            let ta2 = realm.objects(Item.self).filter("name BEGINSWITH '卵'")
            items.append(contentsOf: ta1)
            items.append(contentsOf: ta2)
        }
        if memoTextField.text?.prefix(1) == "ち"{
            let ti1 = realm.objects(Item.self).filter("name BEGINSWITH '中華'")
            items.append(contentsOf: ti1)
        }
        if memoTextField.text?.prefix(1) == "つ"{
            let tu1 = realm.objects(Item.self).filter("name BEGINSWITH '漬物'")
            let tu2 = realm.objects(Item.self).filter("name BEGINSWITH '爪'")
            items.append(contentsOf: tu1)
            items.append(contentsOf: tu2)
        }
        if memoTextField.text?.prefix(1) == "て"{
            let te1 = realm.objects(Item.self).filter("name BEGINSWITH '天'")
            let te2 = realm.objects(Item.self).filter("name BEGINSWITH '手'")
            items.append(contentsOf: te1)
            items.append(contentsOf: te2)
        }
        if memoTextField.text?.prefix(1) == "と"{
            let to1 = realm.objects(Item.self).filter("name BEGINSWITH '鶏'")
            let to2 = realm.objects(Item.self).filter("name BEGINSWITH '唐辛子'")
            let to3 = realm.objects(Item.self).filter("name BEGINSWITH '豆'")

            items.append(contentsOf: to1)
            items.append(contentsOf: to2)
            items.append(contentsOf: to3)
        }
        if memoTextField.text?.prefix(1) == "な"{
            let na1 = realm.objects(Item.self).filter("name BEGINSWITH '生'")
            let na2 = realm.objects(Item.self).filter("name BEGINSWITH '茄子'")
            let na3 = realm.objects(Item.self).filter("name BEGINSWITH '納豆'")

            items.append(contentsOf: na1)
            items.append(contentsOf: na2)
            items.append(contentsOf: na3)
        }
        if memoTextField.text?.prefix(1) == "に"{
            let ni1 = realm.objects(Item.self).filter("name BEGINSWITH '煮'")
            let ni2 = realm.objects(Item.self).filter("name BEGINSWITH '人参'")
            let ni3 = realm.objects(Item.self).filter("name BEGINSWITH '乳液'")

            items.append(contentsOf: ni1)
            items.append(contentsOf: ni2)
            items.append(contentsOf: ni3)
        }
        if memoTextField.text?.prefix(1) == "ね"{
            let ne1 = realm.objects(Item.self).filter("name BEGINSWITH '熱'")
            items.append(contentsOf: ne1)
        }
        if memoTextField.text?.prefix(1) == "は"{
            let ha1 = realm.objects(Item.self).filter("name BEGINSWITH '春巻'")
            let ha2 = realm.objects(Item.self).filter("name BEGINSWITH '歯'")

            items.append(contentsOf: ha1)
            items.append(contentsOf: ha2)
        }
        if memoTextField.text?.prefix(1) == "ひ"{
            let hi1 = realm.objects(Item.self).filter("name BEGINSWITH '冷奴'")
            items.append(contentsOf: hi1)
            let hi2 = realm.objects(Item.self).filter("name BEGINSWITH '漂白'")
            items.append(contentsOf: hi2)
        }
        if memoTextField.text?.prefix(1) == "ほ"{
            let ho1 = realm.objects(Item.self).filter("name BEGINSWITH '芳香剤'")

            items.append(contentsOf: ho1)
        }
        if memoTextField.text?.prefix(1) == "ま"{
            let ma1 = realm.objects(Item.self).filter("name BEGINSWITH '抹茶'")
            let ma2 = realm.objects(Item.self).filter("name BEGINSWITH '松'")
            let ma3 = realm.objects(Item.self).filter("name BEGINSWITH '舞'")
            let ma4 = realm.objects(Item.self).filter("name BEGINSWITH '饅頭'")

            items.append(contentsOf: ma1)
            items.append(contentsOf: ma2)
            items.append(contentsOf: ma3)
            items.append(contentsOf: ma4)
        }
        if memoTextField.text?.prefix(1) == "み"{
            let mi1 = realm.objects(Item.self).filter("name BEGINSWITH '味'")
            items.append(contentsOf: mi1)
            let mi2 = realm.objects(Item.self).filter("name BEGINSWITH '三ツ矢'")
            items.append(contentsOf: mi2)
        }
        if memoTextField.text?.prefix(1) == "め"{
            let me1 = realm.objects(Item.self).filter("name BEGINSWITH '明'")
            items.append(contentsOf: me1)
            let me2 = realm.objects(Item.self).filter("name BEGINSWITH '綿'")
            items.append(contentsOf: me2)
        }
        if memoTextField.text?.prefix(1) == "も"{
            let mo1 = realm.objects(Item.self).filter("name BEGINSWITH '木綿'")
            items.append(contentsOf: mo1)
        }
        if memoTextField.text?.prefix(1) == "む"{
            let mu1 = realm.objects(Item.self).filter("name BEGINSWITH '麦茶'")
            let mu2 = realm.objects(Item.self).filter("name BEGINSWITH '麦飯'")
            let mu3 = realm.objects(Item.self).filter("name BEGINSWITH '無洗'")

            items.append(contentsOf: mu1)
            items.append(contentsOf: mu2)
            items.append(contentsOf: mu3)
        }
        if memoTextField.text?.prefix(1) == "や"{
            let ya1 = realm.objects(Item.self).filter("name BEGINSWITH '野菜'")

            items.append(contentsOf: ya1)
        }
        if memoTextField.text?.prefix(1) == "ゆ"{
            let yu1 = realm.objects(Item.self).filter("name BEGINSWITH '油淋鶏'")
            let yu2 = realm.objects(Item.self).filter("name BEGINSWITH '雪'")
            let yu3 = realm.objects(Item.self).filter("name BEGINSWITH '柚子'")
            let yu4 = realm.objects(Item.self).filter("name BEGINSWITH 'U'")

            items.append(contentsOf: yu1)
            items.append(contentsOf: yu2)
            items.append(contentsOf: yu3)
            items.append(contentsOf: yu4)
        }
        if memoTextField.text?.prefix(1) == "よ"{
            let yo1 = realm.objects(Item.self).filter("name BEGINSWITH '吉'")
            let yo2 = realm.objects(Item.self).filter("name BEGINSWITH '洋'")

            items.append(contentsOf: yo1)
            items.append(contentsOf: yo2)
        }
        if memoTextField.text?.prefix(1) == "り"{
            let ri1 = realm.objects(Item.self).filter("name BEGINSWITH '緑茶'")

            items.append(contentsOf: ri1)
        }
        if memoTextField.text?.prefix(1) == "れ"{
            let re1 = realm.objects(Item.self).filter("name BEGINSWITH '冷麺'")
            let re2 = realm.objects(Item.self).filter("name BEGINSWITH '練乳'")
            let re3 = realm.objects(Item.self).filter("name BEGINSWITH '冷凍'")

            items.append(contentsOf: re1)
            items.append(contentsOf: re2)
            items.append(contentsOf: re3)
        }
        if memoTextField.text?.prefix(1) == "わ"{
            let wa1 = realm.objects(Item.self).filter("name BEGINSWITH '割り'")

            items.append(contentsOf: wa1)
        }
        if memoTextField.text?.prefix(1) == "ぎ" {
            let gi1 = realm.objects(Item.self).filter("name BEGINSWITH '牛'")
            let gi2 = realm.objects(Item.self).filter("name BEGINSWITH '餃'")
            let gi3 = realm.objects(Item.self).filter("name BEGINSWITH '魚'")
            let gi4 = realm.objects(Item.self).filter("name BEGINSWITH '銀'")

            items.append(contentsOf: gi1)
            items.append(contentsOf: gi2)
            items.append(contentsOf: gi3)
            items.append(contentsOf: gi4)
        }
        if memoTextField.text?.prefix(1) == "げ"{
            let ge1 = realm.objects(Item.self).filter("name BEGINSWITH '玄米'")
            let ge2 = realm.objects(Item.self).filter("name BEGINSWITH '激辛'")

            items.append(contentsOf: ge1)
            items.append(contentsOf: ge2)
        }
        if memoTextField.text?.prefix(1) == "ざ"{
            let za1 = realm.objects(Item.self).filter("name BEGINSWITH '雑穀'")
            let za2 = realm.objects(Item.self).filter("name BEGINSWITH '柘榴'")

            items.append(contentsOf: za1)
            items.append(contentsOf: za2)
        }
        if memoTextField.text?.prefix(1) == "じ"{
            let zi1 = realm.objects(Item.self).filter("name BEGINSWITH '柔軟'")
            let zi2 = realm.objects(Item.self).filter("name BEGINSWITH '上白'")

            items.append(contentsOf: zi1)
            items.append(contentsOf: zi2)
        }
        if memoTextField.text?.prefix(1) == "ぜ"{
            let ze1 = realm.objects(Item.self).filter("name BEGINSWITH '全'")

            items.append(contentsOf: ze1)
        }
        if memoTextField.text?.prefix(1) == "ぞ"{
            let zo1 = realm.objects(Item.self).filter("name BEGINSWITH '雑炊'")

            items.append(contentsOf: zo1)
        }
        if memoTextField.text?.prefix(1) == "だ"{
            let da1 = realm.objects(Item.self).filter("name BEGINSWITH '大'")

            items.append(contentsOf: da1)
        }
        if memoTextField.text?.prefix(1) == "で"{
            let de1 = realm.objects(Item.self).filter("name BEGINSWITH '電池'")

            items.append(contentsOf: de1)
        }
        if memoTextField.text?.prefix(1) == "ぶ"{
            let bu1 = realm.objects(Item.self).filter("name BEGINSWITH '豚'")

            items.append(contentsOf: bu1)
        }
        items.append(contentsOf: itemArray1)
        items.append(contentsOf: itemArray2)
        tableView.reloadData()
    }
    
    // MARK: - Helpers
    
    @objc func textFieldDidChange() {
        fetchItem()
    }
    
    private func setup() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapPlusImageView))
        plusImageView.addGestureRecognizer(tap)
        navigationItem.title = "買い物メモ"
        
        tableView.tableFooterView = UIView()
        createButton.layer.cornerRadius = 5
        
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        memoTextField.delegate = self
        memoTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        memoTextField.becomeFirstResponder()
    }
    
    private func setupTextField() {
        
        switch (UIScreen.main.nativeBounds.height) {
        //iPhone8
        case 1334:
            viewBottomConst.constant = -211
            break
        //iPhone8Plus
        case 1792:
            viewBottomConst.constant = -263
            break
        //iPhone12mini
        case 2208:
            viewBottomConst.constant = -222
            break
        //iPhone11 & iPhone11Pro
        case 2436:
            viewBottomConst.constant = -253
            break
        //iPhone12
        case 2532:
            viewBottomConst.constant = -253
            break
        //iPhone11ProMax
        case 2688:
            viewBottomConst.constant = -263
            break
        //iPhone12ProMax
        case 2778:
            viewBottomConst.constant = -263
            break
        default:
            break
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        UserDefaults.standard.set(true, forKey: BACK)
        UserDefaults.standard.removeObject(forKey: CLOSE)
        navigationController?.popViewController(animated: false)
        return true
    }
}

// MARK: - Table view

extension ItemListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ItemListTableViewCell
        
        cell.itemVC = self
        cell.item = items[indexPath.row]
        cell.configureCell(items[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
            UserDefaults.standard.set(items[indexPath.row].name, forKey: "itemName")
            navigationController?.popViewController(animated: false)
            UserDefaults.standard.removeObject(forKey: CLOSE)
            UserDefaults.standard.set(true, forKey: BACK)
        }
    }
}

extension ItemListViewController: EmptyDataSetSource, EmptyDataSetDelegate {
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(named: O_BLACK) as Any, .font: UIFont(name: "HiraMaruProN-W4", size: 15) as Any]
        return NSAttributedString(string: "入力候補はありません", attributes: attributes)
    }
}
