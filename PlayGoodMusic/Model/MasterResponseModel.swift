//
//  MasterResponseModel.swift
//  PlayGoodMusic
//
//  Created by 13216146 on 14/06/20.
//  Copyright © 2020 13216146. All rights reserved.
//

import Foundation

struct MasterResponseModel : Codable {
    let code : Int?
    let result : MasterApiResult?

    enum CodingKeys: String, CodingKey {

        case code = "code"
        case result = "result"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(Int.self, forKey: .code)
        result = try values.decodeIfPresent(MasterApiResult.self, forKey: .result)
    }

}

struct MasterApiResult : Codable {
    let abuse : String?
    let add : String?
    let addetail : String?
    let analytics : String?
    let autosuggest : String?
    let catlist : String?
    let channel_detail : String?
    let channel_list : String?
    let clear_watch : String?
    let comment_add : String?
    let comment_list : String?
    let contact_us : String?
    let coupon_validate : String?
    let csession : String?
    let detail : String?
    let deviceinfo : String?
    let dislike : String?
    let dvr_url : String?
    let edit : String?
    let favlist : String?
    let favorite : String?
    let feedback : String?
    let forgot : String?
    let home : String?
    let home_content : String?
    let ifallowed : String?
    let isplaybackallowed : String?
    let like : String?
    let list : String?
    let live : String?
    let login : String?
    let menu : String?
    let otp_generate : String?
    let pages : String?
    let playlist : String?
    let privacy_policy : String?
    let push_content : String?
    let rating : String?
    let recomended : String?
    let search : String?
    let social : String?
    let subs_cancel_subscription : String?
    let subs_complete_gift_order : String?
    let subs_complete_order_autorenewl : String?
    let subs_complete_order_onetime : String?
    let subs_create_gift_order : String?
    let subs_create_order_autorenewl : String?
    let subs_create_order_onetime : String?
    let subs_free_subscription : String?
    let subs_package_list : String?
    let subs_paytm_checksum : String?
    let subs_paytm_verifychecksum : String?
    let subs_redeem_coupon : String?
    let subs_redeem_refferal : String?
    let subs_user_subscriptions : String?
    let subscribe : String?
    let t_c : String?
    let udatedevice : String?
    let unsubscribe : String?
    let user_behavior : String?
    let userrelated : String?
    let verify_otp : String?
    let version : String?
    let version_check : String?
    let watchduration : String?

    enum CodingKeys: String, CodingKey {

        case abuse = "abuse"
        case add = "add"
        case addetail = "addetail"
        case analytics = "analytics"
        case autosuggest = "autosuggest"
        case catlist = "catlist"
        case channel_detail = "channel_detail"
        case channel_list = "channel_list"
        case clear_watch = "clear_watch"
        case comment_add = "comment_add"
        case comment_list = "comment_list"
        case contact_us = "contact_us"
        case coupon_validate = "coupon_validate"
        case csession = "csession"
        case detail = "detail"
        case deviceinfo = "deviceinfo"
        case dislike = "dislike"
        case dvr_url = "dvr_url"
        case edit = "edit"
        case favlist = "favlist"
        case favorite = "favorite"
        case feedback = "feedback"
        case forgot = "forgot"
        case home = "home"
        case home_content = "home_content"
        case ifallowed = "ifallowed"
        case isplaybackallowed = "isplaybackallowed"
        case like = "like"
        case list = "list"
        case live = "live"
        case login = "login"
        case menu = "menu"
        case otp_generate = "otp_generate"
        case pages = "pages"
        case playlist = "playlist"
        case privacy_policy = "privacy_policy"
        case push_content = "push_content"
        case rating = "rating"
        case recomended = "recomended"
        case search = "search"
        case social = "social"
        case subs_cancel_subscription = "subs_cancel_subscription"
        case subs_complete_gift_order = "subs_complete_gift_order"
        case subs_complete_order_autorenewl = "subs_complete_order_autorenewl"
        case subs_complete_order_onetime = "subs_complete_order_onetime"
        case subs_create_gift_order = "subs_create_gift_order"
        case subs_create_order_autorenewl = "subs_create_order_autorenewl"
        case subs_create_order_onetime = "subs_create_order_onetime"
        case subs_free_subscription = "subs_free_subscription"
        case subs_package_list = "subs_package_list"
        case subs_paytm_checksum = "subs_paytm_checksum"
        case subs_paytm_verifychecksum = "subs_paytm_verifychecksum"
        case subs_redeem_coupon = "subs_redeem_coupon"
        case subs_redeem_refferal = "subs_redeem_refferal"
        case subs_user_subscriptions = "subs_user_subscriptions"
        case subscribe = "subscribe"
        case t_c = "t_c"
        case udatedevice = "udatedevice"
        case unsubscribe = "unsubscribe"
        case user_behavior = "user_behavior"
        case userrelated = "userrelated"
        case verify_otp = "verify_otp"
        case version = "version"
        case version_check = "version_check"
        case watchduration = "watchduration"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        abuse = try values.decodeIfPresent(String.self, forKey: .abuse)
        add = try values.decodeIfPresent(String.self, forKey: .add)
        addetail = try values.decodeIfPresent(String.self, forKey: .addetail)
        analytics = try values.decodeIfPresent(String.self, forKey: .analytics)
        autosuggest = try values.decodeIfPresent(String.self, forKey: .autosuggest)
        catlist = try values.decodeIfPresent(String.self, forKey: .catlist)
        channel_detail = try values.decodeIfPresent(String.self, forKey: .channel_detail)
        channel_list = try values.decodeIfPresent(String.self, forKey: .channel_list)
        clear_watch = try values.decodeIfPresent(String.self, forKey: .clear_watch)
        comment_add = try values.decodeIfPresent(String.self, forKey: .comment_add)
        comment_list = try values.decodeIfPresent(String.self, forKey: .comment_list)
        contact_us = try values.decodeIfPresent(String.self, forKey: .contact_us)
        coupon_validate = try values.decodeIfPresent(String.self, forKey: .coupon_validate)
        csession = try values.decodeIfPresent(String.self, forKey: .csession)
        detail = try values.decodeIfPresent(String.self, forKey: .detail)
        deviceinfo = try values.decodeIfPresent(String.self, forKey: .deviceinfo)
        dislike = try values.decodeIfPresent(String.self, forKey: .dislike)
        dvr_url = try values.decodeIfPresent(String.self, forKey: .dvr_url)
        edit = try values.decodeIfPresent(String.self, forKey: .edit)
        favlist = try values.decodeIfPresent(String.self, forKey: .favlist)
        favorite = try values.decodeIfPresent(String.self, forKey: .favorite)
        feedback = try values.decodeIfPresent(String.self, forKey: .feedback)
        forgot = try values.decodeIfPresent(String.self, forKey: .forgot)
        home = try values.decodeIfPresent(String.self, forKey: .home)
        home_content = try values.decodeIfPresent(String.self, forKey: .home_content)
        ifallowed = try values.decodeIfPresent(String.self, forKey: .ifallowed)
        isplaybackallowed = try values.decodeIfPresent(String.self, forKey: .isplaybackallowed)
        like = try values.decodeIfPresent(String.self, forKey: .like)
        list = try values.decodeIfPresent(String.self, forKey: .list)
        live = try values.decodeIfPresent(String.self, forKey: .live)
        login = try values.decodeIfPresent(String.self, forKey: .login)
        menu = try values.decodeIfPresent(String.self, forKey: .menu)
        otp_generate = try values.decodeIfPresent(String.self, forKey: .otp_generate)
        pages = try values.decodeIfPresent(String.self, forKey: .pages)
        playlist = try values.decodeIfPresent(String.self, forKey: .playlist)
        privacy_policy = try values.decodeIfPresent(String.self, forKey: .privacy_policy)
        push_content = try values.decodeIfPresent(String.self, forKey: .push_content)
        rating = try values.decodeIfPresent(String.self, forKey: .rating)
        recomended = try values.decodeIfPresent(String.self, forKey: .recomended)
        search = try values.decodeIfPresent(String.self, forKey: .search)
        social = try values.decodeIfPresent(String.self, forKey: .social)
        subs_cancel_subscription = try values.decodeIfPresent(String.self, forKey: .subs_cancel_subscription)
        subs_complete_gift_order = try values.decodeIfPresent(String.self, forKey: .subs_complete_gift_order)
        subs_complete_order_autorenewl = try values.decodeIfPresent(String.self, forKey: .subs_complete_order_autorenewl)
        subs_complete_order_onetime = try values.decodeIfPresent(String.self, forKey: .subs_complete_order_onetime)
        subs_create_gift_order = try values.decodeIfPresent(String.self, forKey: .subs_create_gift_order)
        subs_create_order_autorenewl = try values.decodeIfPresent(String.self, forKey: .subs_create_order_autorenewl)
        subs_create_order_onetime = try values.decodeIfPresent(String.self, forKey: .subs_create_order_onetime)
        subs_free_subscription = try values.decodeIfPresent(String.self, forKey: .subs_free_subscription)
        subs_package_list = try values.decodeIfPresent(String.self, forKey: .subs_package_list)
        subs_paytm_checksum = try values.decodeIfPresent(String.self, forKey: .subs_paytm_checksum)
        subs_paytm_verifychecksum = try values.decodeIfPresent(String.self, forKey: .subs_paytm_verifychecksum)
        subs_redeem_coupon = try values.decodeIfPresent(String.self, forKey: .subs_redeem_coupon)
        subs_redeem_refferal = try values.decodeIfPresent(String.self, forKey: .subs_redeem_refferal)
        subs_user_subscriptions = try values.decodeIfPresent(String.self, forKey: .subs_user_subscriptions)
        subscribe = try values.decodeIfPresent(String.self, forKey: .subscribe)
        t_c = try values.decodeIfPresent(String.self, forKey: .t_c)
        udatedevice = try values.decodeIfPresent(String.self, forKey: .udatedevice)
        unsubscribe = try values.decodeIfPresent(String.self, forKey: .unsubscribe)
        user_behavior = try values.decodeIfPresent(String.self, forKey: .user_behavior)
        userrelated = try values.decodeIfPresent(String.self, forKey: .userrelated)
        verify_otp = try values.decodeIfPresent(String.self, forKey: .verify_otp)
        version = try values.decodeIfPresent(String.self, forKey: .version)
        version_check = try values.decodeIfPresent(String.self, forKey: .version_check)
        watchduration = try values.decodeIfPresent(String.self, forKey: .watchduration)
    }

}
