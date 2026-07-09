local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local AvatarExperienceCatalogParent = AvatarExperienceCatalog.Parent
local Players = game:GetService("Players")
local React = require(AvatarExperienceCatalogParent.React)
local FFlagAXCatalogOffersClearOnLogout = require(AvatarExperienceCatalogParent.AvatarExperienceFlags).FFlagAXCatalogOffersClearOnLogout

require(AvatarExperienceCatalog.Stores.createCatalogOffersBannerStore)

local getLocalUserId = require(AvatarExperienceCatalog.Utils.getLocalUserId)

local function useCatalogOffersBannerOffersFetch(p1, p2) -- line: 51
	-- upvalues: FFlagAXCatalogOffersClearOnLogout (copy), React (copy), getLocalUserId (copy), Players (copy)
	if FFlagAXCatalogOffersClearOnLogout then
		React.useEffect(function() -- line: 56
			-- upvalues: p1 (copy), p2 (copy), getLocalUserId (copy), Players (copy)
			local u10 = nil

			if not p1.getHasCompletedOffersFetch(false) and not p1.getOffersFetchInProgress(false) then
				u10 = p1.fetchOffers(p2)
			end

			local u11 = getLocalUserId(Players)

			local function handle() -- line: 76
				-- upvalues: getLocalUserId (copy), Players (copy), u11 (ref), u10 (ref), p1 (copy), p2 (copy)
				local v17 = getLocalUserId(Players)

				if v17 == u11 then
					return
				end

				u11 = v17

				if u10 then
					u10()
					u10 = nil
				end

				p1.setPayload(nil)
				p1.setDismissed(false)

				if v17 ~= nil and v17 ~= "-1" then
					u10 = p1.fetchOffers(p2)
				end
			end

			local u13 = nil

			local function bindUserIdSignal() -- line: 98
				-- upvalues: u13 (ref), Players (copy), handle (copy)
				if u13 then
					u13:Disconnect()
					u13 = nil
				end

				local LocalPlayer = Players.LocalPlayer

				if LocalPlayer ~= nil then
					u13 = LocalPlayer:GetPropertyChangedSignal("UserId"):Connect(handle)
				end
			end

			if u13 then
				u13:Disconnect()
				u13 = nil
			end

			local LocalPlayer = Players.LocalPlayer

			if LocalPlayer ~= nil then
				u13 = LocalPlayer:GetPropertyChangedSignal("UserId"):Connect(handle)
			end

			local connection = Players:GetPropertyChangedSignal("LocalPlayer"):Connect(function() -- line: 111
				-- upvalues: u13 (ref), Players (copy), handle (copy)
				if u13 then
					u13:Disconnect()
					u13 = nil
				end

				local LocalPlayer2 = Players.LocalPlayer

				if LocalPlayer2 ~= nil then
					u13 = LocalPlayer2:GetPropertyChangedSignal("UserId"):Connect(handle)
				end

				handle()
			end)

			return function() -- line: 116
				-- upvalues: u10 (ref), u13 (ref), connection (copy)
				if u10 then
					u10()
					u10 = nil
				end

				if u13 then
					u13:Disconnect()
					u13 = nil
				end

				connection:Disconnect()
			end
		end, {
			p1,
			p2
		})

		return
	end

	React.useEffect(function() -- line: 129
		-- upvalues: p1 (copy), p2 (copy)
		if p1.getHasCompletedOffersFetch(false) or p1.getOffersFetchInProgress(false) then
			return function() -- line: 134
			end
		end

		return p1.fetchOffers(p2)
	end, {
		p2,
		p1
	})
end

return useCatalogOffersBannerOffersFetch
