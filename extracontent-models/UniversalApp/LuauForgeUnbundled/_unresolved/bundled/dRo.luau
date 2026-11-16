local module = require("@luauforge/bundled/dPU")
local module2 = require("@luauforge/bundled/dRp")

local module3 = require("@luauforge/bundled/dQS")
local module4 = require("@luauforge/bundled/dPZ")
local module5 = require("@luauforge/bundled/dRq")
local module6 = require("@luauforge/bundled/dRr")
local mutedError = require("@luauforge/bundled/dRs").mutedError
local module7 = require("@luauforge/bundled/dQa")
local module8 = require("@luauforge/bundled/dRt")

local module9 = require("@luauforge/bundled/dRu")

local module10 = require("@luauforge/bundled/dRv")

local module11 = require("@luauforge/bundled/dRw")

local categoryMenu = module5.CategoryMenu
local sduiErrorType = module7.SduiErrors.SduiErrorType
local useSelectorSignal = module3.Hooks.useSelectorSignal

local fFlagAXMigrateAllTabToSduiDev = module4.FFlagAXMigrateAllTabToSduiDev

local set = {}

for k, v5 in module6.Enums.IconName do
	set[k] = true

	if typeof(v5) == "string" then
		set[v5] = true
	end
end

local function wrapZeroArgAction(callback)
	return function()
		if typeof(callback) == "function" then
			callback(nil, nil, nil)
		else
			mutedError(`Expected function, got {typeof(callback)}`)
		end
	end
end

local function mapButtons(buttons, sduiContext, p2)
	if not buttons then
		return nil
	end

	local clones = {}

	for k, item in buttons do
		if set[item.icon] then
			local clone = table.clone(item)
			local onActivated = item.onActivated

			function clone.onActivated()
				if typeof(onActivated) == "function" then
					onActivated(nil, nil, nil)
				else
					mutedError(`Expected function, got {typeof(onActivated)}`)
				end
			end
			local v5 = if p2 then p2[item.icon] else nil

			if v5 and v5 > 0 then
				clone.badgeCount = v5
			end

			table.insert(clones, clone)
		else
			sduiContext.dependencies.logger.reportError(
				sduiErrorType.InvalidProps,
				{
					name = "CatalogCategoryMenu",
					message = `Skipping button "{item.id}": unknown icon "{item.icon}"`
				},
				sduiContext.appPage
			)
		end
	end

	return clones
end

local function mapTooltips(tooltips)
	if not tooltips then
		return nil
	end

	local clones = {}

	for k, item in tooltips do
		local clone = table.clone(item)

		if clone.actions then
			local clones2 = {}

			for k2, action in clone.actions do
				local clone2 = table.clone(action)
				local onActivated = clone2.onActivated

				function clone2.onActivated()
					if typeof(onActivated) == "function" then
						onActivated(nil, nil, nil)
					else
						mutedError(`Expected function, got {typeof(onActivated)}`)
					end
				end
				clones2[k2] = clone2
			end

			clone.actions = clones2
		end

		if clone.onClose then
			local onClose = clone.onClose

			function clone.onClose()
				if typeof(onClose) == "function" then
					onClose(nil, nil, nil)
				else
					mutedError(`Expected function, got {typeof(onClose)}`)
				end
			end
		end

		clones[k] = clone
	end

	return clones
end

local function SduiCatalogCategoryMenu(props)
	local v5 = module8()
	local v6 = module2.useSignalState(v5.activeCategoryId)
	local v7 = module2.useSignalState(v5.activeSubcategoryId)
	local v8

	if fFlagAXMigrateAllTabToSduiDev then
		local v9 = useSelectorSignal(module11)
		local v10 = module2.useSignalState(v9)
		v8 = module.useMemo(function()
			if v10 and v10 > 0 then
				return {
					ThreeSlidersHorizontal = v10,
					[module6.Enums.IconName.ThreeSlidersHorizontal] = v10
				}
			end

			return nil
		end, { v10 })
	else
		v8 = nil
	end

	local v9

	if fFlagAXMigrateAllTabToSduiDev then
		v9 = module.useMemo(function()
			if v6 == nil or v7 == nil then
				return nil
			end

			local flag = false

			for k, category in props.categories do
				if category.id == v6 then
					return nil
				end

				if category.id == v7 then
					flag = true
				end
			end

			if flag then
				return v7
			end

			return nil
		end, { v6, v7, props.categories })
	end

	local v10 = v9 or v6 or props.activeCategoryId

	local v11 = module9(v10)

	local v12 = module10(v10)

	local v13 = if v9 == nil then v7 else nil

	local v14 = {
		activeCategoryId = v10,
		activeSubcategoryId = v13 or v12 or props.activeSubcategoryId,
		categories = props.categories,
		buttonsLocation = props.buttonsLocation
	}

	v14.onCategoryActivated = module.useCallback(function(p2)
		if typeof(props.onCategoryActivated) == "function" then
			props.onCategoryActivated(nil, nil, { categoryId = p2 })
		end
	end, { props.onCategoryActivated })

	v14.onSubcategoryActivated = module.useCallback(function(p2)
		if typeof(props.onSubcategoryActivated) == "function" then
			props.onSubcategoryActivated(nil, nil, { subcategoryId = p2 })
		end
	end, { props.onSubcategoryActivated })

	v14.buttons = module.useMemo(function()
		return mapButtons(props.buttons, props.sduiContext, v8)
	end, { props.buttons, props.sduiContext, v8 })

	v14.tooltips = module.useMemo(function()
		return mapTooltips(props.tooltips)
	end, { props.tooltips })

	v14.subcategories = module.useMemo(function()
		return v11
	end, { v11 })

	return module.createElement(categoryMenu, v14)
end

return module.memo(SduiCatalogCategoryMenu)
