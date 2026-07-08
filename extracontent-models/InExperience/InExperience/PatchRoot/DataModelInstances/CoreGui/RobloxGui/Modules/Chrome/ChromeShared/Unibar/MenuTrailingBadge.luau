local ChromeShared = script:FindFirstAncestor("ChromeShared")
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local Badge = Foundation.Badge
local View = Foundation.View
local BadgeVariant = Foundation.Enums.BadgeVariant
local BadgeShape = Foundation.Enums.BadgeShape
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local Service = require(ChromeShared.Service)
local LocalStore = require(ChromeShared.Service.LocalStore)

require(CorePackages.Workspace.Packages.Chrome)

local t1 = {}

local function hasBeenDismissed(s1: string, p1) -- line: 56
	-- upvalues: t1 (copy), LocalStore (copy)
	if t1[s1] then
		return true
	end

	local maxViewCount = p1.maxViewCount

	if maxViewCount <= 0 then
		return true
	end

	local v19 = LocalStore.getValue(p1.localStorageKey)

	return maxViewCount <= (type(v19) ~= "number" and 0 or v19)
end
local function recordView(p2) -- line: 74
	-- upvalues: LocalStore (copy)
	if p2.maxViewCount <= 0 then
		return
	end

	local v21 = LocalStore.getValue(p2.localStorageKey)
	local v22 = type(v21) ~= "number" and 0 or v21

	LocalStore.storeForLocalPlayer(p2.localStorageKey, v22 + 1)
end
local function MenuTrailingBadge(t2: {[any]: any}) -- line: 83
	-- upvalues: React (copy), t1 (copy), LocalStore (copy), useLocalization (copy), Service (copy), View (copy), Badge (copy), BadgeVariant (copy), BadgeShape (copy)
	local integrationId = t2.integrationId
	local config = t2.config
	local v26, v27 = React.useState(function() -- line: 87
		-- upvalues: integrationId (copy), config (copy), t1 (copy), LocalStore (copy)
		local v29 = integrationId
		local v30 = config
		local v31

		if t1[v29] then
			v31 = true
		else
			local maxViewCount = v30.maxViewCount

			if maxViewCount <= 0 then
				v31 = true
			else
				local v33 = LocalStore.getValue(v30.localStorageKey)

				v31 = maxViewCount <= (type(v33) ~= "number" and 0 or v33)
			end
		end

		local v34 = not v31

		if v34 then
			local v35 = config

			if v35.maxViewCount <= 0 then
				return v34
			end

			local v36 = LocalStore.getValue(v35.localStorageKey)
			local v37 = type(v36) ~= "number" and 0 or v36

			LocalStore.storeForLocalPlayer(v35.localStorageKey, v37 + 1)
		end

		return v34
	end)
	local v28 = useLocalization({
		text = "Feature.Catalog.Label.New"
	})

	React.useEffect(function() -- line: 101
		-- upvalues: v26 (copy), Service (copy), integrationId (copy), t1 (copy), LocalStore (copy), config (copy), v27 (copy)
		if not v26 then
			return
		end

		local v38 = Service:onIntegrationActivated():connect(function(p3) -- line: 106
			-- upvalues: integrationId (copy), t1 (copy), LocalStore (copy), config (copy), v27 (copy)
			if p3 ~= integrationId then
				return
			end

			t1[integrationId] = true
			LocalStore.storeForLocalPlayer(config.localStorageKey, config.maxViewCount)
			v27(false)
		end)

		return function() -- line: 115
			-- upvalues: v38 (copy)
			v38:disconnect()
		end
	end, {
		integrationId,
		config.localStorageKey,
		config.maxViewCount,
		v26
	})

	if not v26 then
		return nil
	end

	return React.createElement(View, {
		tag = "auto-xy",
		LayoutOrder = t2.layoutOrder
	}, {
		Badge = React.createElement(Badge, {
			text = v28.text,
			variant = BadgeVariant.Emphasis,
			shape = BadgeShape.Box
		})
	})
end

return MenuTrailingBadge
