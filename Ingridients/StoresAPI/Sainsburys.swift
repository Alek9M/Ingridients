//
//  Sainsburys.swift
//  Ingridients
//
//  Created by M on 16/03/2023.
//

import Foundation
import SwiftSoup

class Sainsburys: Store, StoreProtocol {
    static var base = URL(string: "https://www.sainsburys.co.uk")!
    static private let shampoos = base.appending(path:"/shop/gb/groceries/beauty-and-cosmetics/CategoryDisplay?langId=44&storeId=10151&catalogId=10241&categoryId=448403&orderBy=FAVOURITES_ONLY%7CSEQUENCING%7CTOP_SELLERS&beginIndex=0&promotionId=&listId=&searchTerm=&hasPreviousOrder=&previousOrderId=&categoryFacetId1=&categoryFacetId2=&ImportedProductsCount=&ImportedStoreName=&ImportedSupermarket=&bundleId=&parent_category_rn=448352&top_category=448352&pageSize=120")
    
    static private let productClass = "product"
    static private let pagesButtonsClass = "pages"
    
    static internal func url(forProducts: Products) -> URL? {
        switch forProducts {
        case .Shampoo:
            return shampoos
        default:
            return nil
        }
    }
    
    func load(_ products: Products) {
        guard let url = Sainsburys.url(forProducts: products) else { return }
        DispatchQueue.global().async {
            self.load(page: URL(string: url.absoluteString.replacing("%3F", with: "?"))!)
        }
    }
    
    private func load(page: URL) {
        
        DispatchQueue.main.async {
            guard !self.loaded.contains(page) else { return }
            self.loaded.append(page)
            print(page.absoluteString)
            
            DispatchQueue.global(qos: .userInitiated).async {
                var request = URLRequest(url: page)
                    request.setValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.3 Safari/605.1.15", forHTTPHeaderField: "User-Agent")
                    request.setValue("www.sainsburys.co.uk", forHTTPHeaderField: "Host")
//                    request.setValue("WC_GENERIC_ACTIVITYDATA=[81922010336%3Atrue%3Afalse%3A0%3AvK7kW1wtnc%2ByrEtTbJIpkoYS98U%3D][com.ibm.commerce.context.entitlement.EntitlementContext|10502%2610502%26null%26-2000%26null%26null%26null][com.sol.commerce.context.SolBusinessContext|null%26null%26null%26null%26null%26null%26null%26null%26false%26false%26false%26null%26false%26null%26false%26false%26null%26false%26false%26false%26null%26false%26false%26false%26null%26null%26null%26null%260%260%26null][com.ibm.commerce.context.audit.AuditContext|1678889781934-91816][com.ibm.commerce.context.globalization.GlobalizationContext|44%26GBP%2644%26GBP][com.ibm.commerce.store.facade.server.context.StoreGeoCodeContext|null%26null%26null%26null%26null%26null][com.ibm.commerce.catalog.businesscontext.CatalogContext|null%26null%26false%26false%26false][com.ibm.commerce.context.experiment.ExperimentContext|null][com.ibm.commerce.context.preview.PreviewContext|null%26null%26false][CTXSETNAME|Store][com.ibm.commerce.context.base.BaseContext|10151%26-1002%26-1002%26-1][com.sol.commerce.catalog.businesscontext.SolCatalogContext|10241%26null%26false%26false%26false%26null%26null]; WC_USERACTIVITY_-1002=-1002%2C10151%2Cnull%2Cnull%2Cnull%2Cnull%2Cnull%2Cnull%2Cnull%2Cnull%2CmVnYsddvB8ADeanLEumg9bYFBel1EBXlG7Ao6qTNCtrQW3z78r13FW%2B1HyZhEzEJg4C9ZvyNGJii1UnMuREJhpfA8oWULSvoevLMXqr9AHyXS%2Fe4iH3j66J7l9cu44kyz2GmiV1CJxw64bNocGLL5tIV7Cn%2FsuELkXVkvH%2BhgQvpFKlp7aYQEI5ySlw6ztmsRtugJGBKY5czX6DVZkO%2BrA%3D%3D; last_button_track=false; search_redirect_flag=0; utag_main=v_id:0186e5a0fdb6001de41c6f17957c01075001d06d008ce$_sn:4$_ss:0$_st:1678933391630$dc_visit:4$ses_id:1678931590423%3Bexp-session$_pn:1%3Bexp-session$dc_event:2%3Bexp-session$dc_region:eu-west-1%3Bexp-session; GOLUI_INTERSTITIALS=on; JSESSIONID=0000ZYOMoXm8H7KtmSEZrTygbXl:1gnhhvdgk; WC_SOL_TEST_UI=newSearchResultPage_on; WC_SOL_TEST_UI_SEED=3234245924; peerius_sess=52854875752|kBeKkpf9nVe5r8rT6rGi323lq7a9vXrrS5vtXKYwId4; peerius_user=cuid:34902816402|wL2RxYrrjAZYfSrI0btUZ83S83KMfK9uQNvDEFXmUYE; prizeDrawPopUp_customer1In20Chance=false; OptanonConsent=isGpcEnabled=0&datestamp=Thu+Mar+16+2023+01%3A53%3A10+GMT%2B0000+(Greenwich+Mean+Time)&version=6.35.0&isIABGlobal=false&hosts=&consentId=0d66291a-cc07-41a3-9865-a81d50fd4040&interactionCount=1&landingPath=NotLandingPage&groups=1%3A1%2C2%3A0%2C3%3A0%2C4%3A0&geolocation=GB%3BENG&AwaitingReconsent=false; SG-GOL-1STGR=1%3A1%2C2%3A0%2C3%3A0%2C4%3A0; OptanonAlertBoxClosed=2023-03-16T01:11:47.709Z; SG-GOL-1ST=1871853556.1678929102; espot_click=nz_homepage_contentespot_01>FoodCupboard_Cadbury_Y_nonvalue_default_Homepage_ShopByCategory_r1p3_N; espot_list_session=nz_homepage_contentespot_01>FoodCupboard_Cadbury_Y_nonvalue_default_Homepage_ShopByCategory_r1p3_N; WC_PERSISTENT=ZL5aHU%2FJPTP%2BvWFpbSbJjVOz1Xg%3D%0A%3B2023-03-15+14%3A16%3A21.934_1678889781934-91816_10151; GOLVI=c6f297361b0542baba0a9e025e335678; cleared-onetrust-cookies=true; SESSION_COOKIEACCEPT=true; WC_ACTIVEPOINTER=44%2C10151; WC_AUTHENTICATION_-1002=-1002%2C3jIiHU%2F3lFc4jalpGDAhYOztAdQ%3D; WC_SESSION_ESTABLISHED=true; AWSELB=25AD1B631266486EDFA612488DCD352CF0D47ECF03731A61102AC915AB71DC4AED5BC436E08F1C9CDECEA01F0FFD5FBE13E2736D58C5A2765603627EB3AB9899FB329D4F55; AWSELBCORS=25AD1B631266486EDFA612488DCD352CF0D47ECF03731A61102AC915AB71DC4AED5BC436E08F1C9CDECEA01F0FFD5FBE13E2736D58C5A2765603627EB3AB9899FB329D4F55; Apache=10.8.240.26.1677838696263532; _abck=E4DF7276BAA87EA2C6D9A03342566605~0~YAAQbTzXF9TR6OSDAQAAogEXFwj9JVTRpz2xF822+fy6A7MEO032zAinWgza0Lz27RwOQE+1z6iBm5Zxl3c8VeEnzgFC/jAxFt7gge/t7T/dmQpuovy5qcdz69BC9K+4VXTu6C/MzPxTNY1SZrgk3aAajaq/yKNUbHBHlfgEEyjmh26mNW9dq4DbHR6b2KIhTlVpMN7abmLE50R4tEXB1Xsm0SUuYuOMKpljIc4drwsn8MvnNb76ZVAs9+/NiVCtCbuYft3EyfhjnF6ygeqXlBz4joq6Nxd28kiqRSfubwEgdIEzVTY0FfcONdsH7oiNOfu0G/9LHpVSA4o3h/bsxDvn9z4LoQ2i3RD/BA3IgQ44Wng8fG7epAoZ5wghYW7b/5NHl+AO6by80KKsRPJKofU4XKEChP+oOjf6fehD7g==~-1~-1~-1", forHTTPHeaderField: "Cookie")
                
                URLSession.shared.dataTask(with: request) {
                    data, response, error in
                            if let error = error { return }
                            
//                            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else { return }
                            
                            guard let data = data, let html = String(data: data, encoding: .utf8) else { return }
                    
                    guard let soup = try? SwiftSoup.parse(html, Sainsburys.shampoos.absoluteString),
                          let pageButtonsRaw = try? soup.getElementsByClass(Sainsburys.pagesButtonsClass).first(),
                          let products = try? soup.getElementsByClass(Sainsburys.productClass),
                          let pageButtons = try? pageButtonsRaw.getElementsByTag("li") else { return }
                    
                    DispatchQueue.main.async {
                        self.productsToLoad += products.count
                    }
                    
                    for url in self.extractPagesURLs(from: pageButtons) {
    //                    DispatchQueue.global().async {
                            self.load(page: url)
    //                    }
                    }
                    
                    for product in products {
//                        DispatchQueue.global().async {
                            self.addProduct(product)
//                        }
                    }
                }.resume()
            }
        }
    }
    
    private func extractPagesURLs(from pageButtons: Elements) -> [URL] {
        return pageButtons.compactMap { li in
            guard let a = try? li.getElementsByTag("a"),
                  let href = try? a.attr("href"),
                  href.count > 0 else { return nil }
            let incorrect = href.replacingOccurrences(of: "%3F", with: "?")
            guard let inc = URL(string: incorrect) else { return nil}
            let correct = inc.absoluteString.replacingOccurrences(of: "%3F", with: "?")
            return URL(string: correct)
        }
    }
    
    private func addProduct(_ product: Element) {
        guard let a = try? product.getElementsByTag("a").first(), //
              let url = try? a.attr("href"), //
              let urlurl = URL(string: url),
              let productHTML = try? String(contentsOf: urlurl),
              let productSoup = try? SwiftSoup.parse(productHTML, urlurl.absoluteString),//
              let ingridientsElement = try? productSoup.getElementsByClass("productIngredients").first(),
              let ingridientsText = try? ingridientsElement.text(), //
              let h3 = try? product.getElementsByTag("h3").first(), //
              let title = try? h3.text(), //
              let price = try? product.getElementsByClass("pricePerUnit").first()?.text(),
              let value = try? product.getElementsByClass("pricePerMeasure").first()?.text()  else { return } // price per
        
        if let product = Product(ingridients: Ingridients(raw: ingridientsText), title: title, price: price, url: Tesco.base.appending(path: url)) {
            DispatchQueue.main.async {
                self.products.append(product)
                self.productsLoaded += 1
                self.objectWillChange.send()
            }
        }
    }
    
}
