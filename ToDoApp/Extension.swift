//
//  Extension.swift
//  ToDoApp
//
//  Created by yuji nakamoto on 2020/11/25.
//

import Foundation
import RealmSwift
import UIKit

extension Realm {
    public func safeWrite(_ block: (() throws -> Void)) throws {
        if isInWriteTransaction {
            try block()
        } else {
            try write(block)
        }
    }
}

extension UIViewController {

    func setSwipeBack() {
        let target = self.navigationController?.value(forKey: "_cachedInteractionController")
        let recognizer = UIPanGestureRecognizer(target: target, action: Selector(("handleNavigationTransition:")))
        self.view.addGestureRecognizer(recognizer)
    }
    
    func selectColor() {
        if UserDefaults.standard.object(forKey: GREEN_COLOR) != nil {
            greenColor()
        } else {
            whiteColor()
        }
    }
    
    func greenColor() {
        navigationController?.navigationBar.barTintColor = UIColor(named: EMERALD_GREEN_ALPHA)
        navigationController?.navigationBar.titleTextAttributes
            = [.foregroundColor: UIColor.white as Any,]
        tabBarController?.tabBar.barTintColor = UIColor(named: EMERALD_GREEN)
        tabBarController?.tabBar.tintColor = UIColor.white
        tabBarController?.tabBar.unselectedItemTintColor = UIColor.systemGray3
    }
    
    func whiteColor() {
        navigationController?.navigationBar.barTintColor = UIColor(named: O_WHITE_ALPHA)
        navigationController?.navigationBar.titleTextAttributes
            = [.foregroundColor: UIColor(named: O_BLACK) as Any,]
        tabBarController?.tabBar.barTintColor = UIColor(named: O_WHITE)
        tabBarController?.tabBar.tintColor = UIColor(named: EMERALD_GREEN)
        tabBarController?.tabBar.unselectedItemTintColor = UIColor.systemGray
    }
}

public let generator = UINotificationFeedbackGenerator()

public var itemArray = ["アイスクリーム","アルミホイル","アクエリアス","アップルパイ","甘酒","揚げ出し豆腐","甘エビ","アボガド","揚げ玉","揚げ物","甘口醤油","あさり","鯵","穴子","いちご","インスタントラーメン","いちごジャム","鰯","芋","いくら","胃薬","痛み止め","糸こんにゃく","いんげん豆","いなり寿司","ウインナー","ウェットティッシュ","ウイスキー","ウォッカ","烏龍茶","うどん","梅酒サワー","海老","えびフィレオ","エクレア","エナジードリンク","エリンギ","枝豆","エスプレッソ","オロナミンC","オリーブオイル","おにぎり","お菓子","お米","オレンジ","オクラ","オレンジジュース","温泉たまご","お好み焼きソース","かぼちゃ","カルピス","カレールー","カップヌードル","カイワレ大根","カレーうどん","海鮮サラダ","唐揚げ","数の子","片栗粉","かぜ薬","かゆみ止め","辛子明太子","キャベツ","キムチ","きゅうり","キクラゲ","絹ごし豆腐","クッキー","クリーム","クミン","クレープ","クロワッサン","クリームコロッケ","ケチャップ","ケーキ","消しゴム","ケンタッキー","化粧水","ゴミ袋","コカ・コーラ","コンソメ","コーヒー","コショウ","こんにゃく","コリアンダー","コシヒカリ","コーンフレーク","コーンポタージュ","小麦粉","濃口醤油","高野豆腐","サーモン","さくらんぼ","サバ缶","刺身","サーターアンダギー","さつま揚げ","皿うどん","さつまいも","鮭フレーク","しらたき","シャープペン","砂糖","サラダオイル","サランラップ","サイコロステーキ","サンドイッチ","シュークリーム","椎茸","シャンプー","ししゃも","上白糖","シュウマイ","シリアル","消臭剤","柔軟剤","C.C.レモン","ショートケーキ","生姜","食パン","醤油","塩コショウ","焼酎","スポンジ","スパゲティー","スパイス","スナック菓子","接着剤","せんべい","洗剤","ソース","素麺","ソーセージ","ソフトクリーム","惣菜","惣菜パン","蕎麦","玉ねぎ","卵","たこわさび","タバスコ","たこ焼き","タピオカミルクティー","たこ焼きソース","タン塩","タオル","たくあん","タンドリーチキン","チョコレート","ティッシュペーパー","チーズ","チキンナゲット","チキンラーメン","チキンクリスプ","チューハイ","ちりめんじゃこ","中華スープ","ツナ缶","漬物","爪楊枝","つぶあん","テキーラ","ティラミス","てりやきマックバーガー","天然水","天かす","天ぷら","手羽先","トマト","とうもろこし","トリュフ","トイレットペーパー","鶏肉","唐辛子","豆板醤","豆腐","豚汁","鶏がらスープ","豆乳","茄子","生クリーム","ナンプラー","生ハム","納豆","ナタデココ","生ビール","にんじん","ニンニク","煮干し","乳液","人参","熱さまシート","海苔","ノンアルコールビール","野沢菜","ハイボール","春巻き","歯磨き粉","歯ブラシ","はちみつ","ハンバーグ","ハーブ","ハンバーガー","ハーゲンダッツ","ハンドソープ","ハーブティー","冷奴","漂白剤","ひき肉","ビニール袋","ひじき","ピーマン","冷やし中華","フランクフルト","フランスパン","フォアグラ","フルーツ","フカヒレ","フレーク","フライドポテト","フライドチキン","フィレオフィッシュ","フライドオニオン","ヘアワックス","ヘアスプレー","芳香剤","ほうれん草","ほうじ茶","ほんだし","ホイップクリーム","ホットケーキミックス","ホワイトソース","ホットック","ホルモン","マーマレード","マシュマロ","マカロニ","マッシュルーム","マヨネーズ","マスカット","抹茶","まぐろ","松茸","マスタード","舞茸","マックシェイク","マジックリン","饅頭","マンゴー","三ツ矢サイダー","ミートボール","みりん","味噌汁","みたらし団子","ミートスパゲティ","ミルクティー","ミネラルウォーター","味噌","無洗米","麦茶","麦飯","鶏むね肉","メープルシロップ","綿棒","明太子","メロン","メロンパン","メガマフィン","めんつゆ","メロンソーダ","鶏もも肉","木綿豆腐","モッツァレラ","モンブラン","もやし","モスコミュール","モンスターエナジー","野菜","油淋鶏","U.F.O.","やきそば","ユッケ","ゆずサワー","雪見だいふく","柚子はちみつ","ヨーグルト","吉野家","洋食","ラー油","ラーメン","ライチ","ライム","リンゴ","リンス","緑茶","ルッコラ","レーズン","レトルトカレー","レタス","レンコン","冷麺","レアチーズケーキ","レモン","練乳","レッドブル","冷凍食品","ロールパン","ローレル","ローストビーフ","ローストチキン","ロコモコ","ロマネコンティ","ローズヒップティー","わさび","割り箸","わかめ","ワッフル","ワンタン","ワイン","ワックス","ガーリック","ガレット","ガラムマサラ","ガトーショコラ","ガナッシュ","牛肉","牛もも肉","牛乳","餃子","餃子タレ","魚肉ソーセージ","銀杏","牛タン","牛丼","魚介類","グラノーラ","グラタン","グレープフルーツ","グリンピース","グレープ","グリーンカレー","グアバ","玄米","玄米フレーク","玄米パン","激辛カレー","激辛ソース","げそフライ","ゴーヤー","ごまラー油","ごはん","ゴボウ","ごま塩","ゴーフレット","ゴディバ","ゴマだれ","ザーサイ","ざる蕎麦","ざるうどん","雑穀米","柘榴","ザンギ","ざらめ砂糖","ジュース","ジャーキー","ジャム","ジンジャエール","じゃがいも","ジャスミン茶","ゼリー","ぜんざい","全粒粉","雑炊","ダージリン","大根","大豆","大福","だし昆布","ダブルチーズバーガー","ダイエットコーラ","デミグラスソース","デザート","電池","ドーナツ","ドライイースト","ドリンク","ドライフルーツ","ドレッシング","ドンタコス","どら焼き","ドンペリ","バームクーヘン","バーボン","バニラアイス","バジル","バナナ","ババロア","バーニャカウダ","バター","バルサミコ酢","ビーフカレー","ビッグマック","ビスケット","ブイヨン","ブランデー","ブロッコリー","ブルーベリー","ブラックペッパー","ブルーチーズ","豚肉","豚バラ","豚キムチ","ベーコン","ベーコンレタスバーガー","ベーグル","ベイクド","ボディソープ","ボールペン","パイナップル","パンケーキ","パルメザンチーズ","パプリカ","パパイヤ","パンナコッタ","パスタ","パスタソース","パン粉","パイタンスープ","ピーナッツ","ピスタチオ","ピーマン","ピザソース","プリン","プチトマト","プロテイン","プレミアムビール","ペペロンチーノ","ペヤング","ポタージュ","ポテトチップス","ポカリスエット","ポン酢","ポップコーン","ポン・デ・リング"]


public func timeAgoSinceDate(_ date:Date, currentDate:Date, numericDates:Bool) -> String {
    let calendar = Calendar.current
    let now = currentDate
    let earliest = (now as NSDate).earlierDate(date)
    let latest = (earliest == now) ? date : now
    let components:DateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.minute , NSCalendar.Unit.hour , NSCalendar.Unit.day , NSCalendar.Unit.weekOfYear , NSCalendar.Unit.month , NSCalendar.Unit.year , NSCalendar.Unit.second], from: earliest, to: latest, options: NSCalendar.Options())
    
    if (components.year! >= 2) {
        return "\(components.year!)年前"
    } else if (components.year! >= 1){
        if (numericDates){ return "1年前"
        } else { return "昨年" }
    } else if (components.month! >= 2) {
        return "\(components.month!)ヶ月前"
    } else if (components.month! >= 1){
        if (numericDates){ return "1ヶ月前"
        } else { return "先月" }
    } else if (components.weekOfYear! >= 2) {
        return "\(components.weekOfYear!)週間前"
    } else if (components.weekOfYear! >= 1){
        if (numericDates){ return "1週間前"
        } else { return "先週" }
    } else if (components.day! >= 2) {
        return "\(components.day!)日前"
    } else if (components.day! >= 1){
        if (numericDates){ return "1日前"
        } else { return "昨日" }
    } else if (components.hour! >= 2) {
        return "\(components.hour!)時間前"
    } else if (components.hour! >= 1){
        if (numericDates){ return "1時間前"
        } else { return "数時間前" }
    } else if (components.minute! >= 2) {
        return "\(components.minute!)分前"
    } else if (components.minute! >= 1){
        if (numericDates){ return "1分前"
        } else { return "数分前" }
    } else if (components.second! >= 3) {
        return "\(components.second!)秒前"
    } else { return "今" }
}
