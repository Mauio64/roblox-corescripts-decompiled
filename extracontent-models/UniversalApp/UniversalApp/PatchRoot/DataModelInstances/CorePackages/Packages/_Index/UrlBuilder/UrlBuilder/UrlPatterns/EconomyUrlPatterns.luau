return function(p)
	return {
		paymentsGateway = {
			getUpsellProduct = p.fromString("apis:payments-gateway/v1/products/get-upsell-product"),
			preparePayment = p.fromString("apis:payments-gateway/v1/prepare-payment"),
			checkUserPurchaseSettings = p.fromString("apis:payments-gateway/v1/check-user-purchase-settings")
		},
		purchaseWarning = {
			getPurchaseWarning = function(p2: string?, p3: number?, flag: boolean?)
				local v

				if p2 == nil then
					if p3 == nil then
						warn(string.format(
							"%s - Invalid parameters, needs mobileProductId or productId",
							(tostring(script.Name))
						))
						return nil
					end

					v = string.format("%s?productId=%d", "apis:purchase-warning/v1/purchase-warnings", p3)
				else
					v = string.format("%s?mobileProductId=%s", "apis:purchase-warning/v1/purchase-warnings", p2)
				end

				if flag then
					v = string.format("%s&is13To17ScaryModalEnabled=True", v)
				end

				return p.fromString(v)()
			end,
			ackPurchaseWarning = p.fromString("apis:purchase-warning/v1/purchase-warnings/acknowledge")
		},
		vngPayments = {
			getVngShopUrl = p.fromString("apis:vng-payments/v1/getVngShopUrl")
		},
		info = {
			developerProduct = p.fromString("www:developer-product/{universeId}/product/{productId}")
		}
	}
end
