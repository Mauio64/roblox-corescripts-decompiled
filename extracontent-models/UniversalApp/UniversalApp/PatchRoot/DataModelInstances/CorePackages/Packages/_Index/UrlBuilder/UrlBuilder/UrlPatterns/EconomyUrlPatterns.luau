return function(p1) -- line: 1
	return {
		paymentsGateway = {
			getUpsellProduct = p1.fromString("apis:payments-gateway/v1/products/get-upsell-product"),
			preparePayment = p1.fromString("apis:payments-gateway/v1/prepare-payment"),
			checkUserPurchaseSettings = p1.fromString("apis:payments-gateway/v1/check-user-purchase-settings")
		},
		purchaseWarning = {
			getPurchaseWarning = function(s1: string?, n1: number?, b1: boolean?) -- line: 9
				-- upvalues: p1 (copy)
				local v5

				if s1 ~= nil then
					v5 = string.format("%s?mobileProductId=%s", "apis:purchase-warning/v1/purchase-warnings", s1)
				else
					if n1 == nil then
						warn(string.format("%s - Invalid parameters, needs mobileProductId or productId", (tostring(script.Name))))

						return nil
					end

					v5 = string.format("%s?productId=%d", "apis:purchase-warning/v1/purchase-warnings", n1)
				end

				if b1 then
					v5 = string.format("%s&is13To17ScaryModalEnabled=True", v5)
				end

				return p1.fromString(v5)()
			end,
			ackPurchaseWarning = p1.fromString("apis:purchase-warning/v1/purchase-warnings/acknowledge")
		},
		vngPayments = {
			getVngShopUrl = p1.fromString("apis:vng-payments/v1/getVngShopUrl")
		},
		info = {
			developerProduct = p1.fromString("www:developer-product/{universeId}/product/{productId}")
		}
	}
end
