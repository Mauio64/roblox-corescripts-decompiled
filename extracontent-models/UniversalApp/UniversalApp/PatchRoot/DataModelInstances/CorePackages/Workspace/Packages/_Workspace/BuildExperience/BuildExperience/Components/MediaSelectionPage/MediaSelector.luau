local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local React = require(BuildExperienceParent.React)
local Foundation = require(BuildExperienceParent.Foundation)
local ScrollView = Foundation.ScrollView
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local getGameMediaForUniverse = require(BuildExperience.utils.getGameMediaForUniverse)
local FilmstripSlot = require(script.Parent.FilmstripSlot)
local MediaPreview = require(script.Parent.MediaPreview)

require(script.Parent.types)

local function IconThumbnailsEditor(t1: {[any]: any}) -- line: 31
	-- upvalues: getGameMediaForUniverse (copy), useTokens (copy), React (copy), FilmstripSlot (copy), View (copy), MediaPreview (copy), ScrollView (copy), Foundation (copy)
	local v13 = getGameMediaForUniverse(t1.universeId)
	local v14 = useTokens()
	local icon = v13.icon
	local v16, v17 = React.useState(v13.thumbnails)
	local v18, v19 = React.useState({
		kind = "icon"
	})
	local v20, v21 = React.useState(false)
	local v22, v23 = React.useState(nil)

	React.useEffect(function() -- line: 41
		-- upvalues: v17 (copy), v13 (copy)
		v17(v13.thumbnails)
	end, { v13.thumbnails })

	local v24 = React.useMemo(function() -- line: 45
		-- upvalues: v16 (copy)
		local t2 = {}

		for _, v51 in v16 do
			table.insert(t2, v51)
		end

		return t2
	end, { v16 })
	local v25 = #v24 < 10
	local v26 = React.useCallback(function(s1: string) -- line: 55
		local t3 = {}

		table.insert(t3, {
			id = "capture_library",
			text = "Capture library",
			icon = "icons/common/image"
		})

		if s1 ~= "icon" and (s1 ~= "thumbnail_1" and s1 ~= "empty") then
			table.insert(t3, {
				id = "delete",
				text = "Delete",
				icon = "icons/common/trash"
			})
		end

		return {{
			items = t3
		}}
	end, {})
	local v27 = React.useCallback(function(s2: string) -- line: 66
		-- upvalues: v23 (copy), v21 (copy)
		v23(s2)
		v21(true)
	end, {})
	local v28 = React.useCallback(function(s3: string) -- line: 71
		-- upvalues: v21 (copy), v22 (copy), v17 (copy), v18 (copy), v19 (copy)
		v21(false)

		if s3 == "capture_library" then
			if v22 == "icon" then
				return
			end

			if v22 == "empty" then
				v17(function(p1) -- line: 80
					return p1
				end)

				return
			end

			v17(function(p2) -- line: 95
				return p2
			end)

			return
		end

		if s3 == "delete" then
			v17(function(p3) -- line: 114
				return p3
			end)

			local v56 = table.clone(v18)

			if v56.kind == "thumbnail" then
				v56.index = v56.index - 1
			end

			v19(v56)
		end
	end, {
		v22,
		v18
	})
	local v29 = React.useCallback(function() -- line: 133
		-- upvalues: v21 (copy)
		v21(false)
	end, {})
	local v30 = React.useCallback(function() -- line: 137
		-- upvalues: v19 (copy)
		v19({
			kind = "icon"
		})
	end, {})
	local v31 = React.useCallback(function(n1: number) -- line: 141
		-- upvalues: v19 (copy)
		v19({
			kind = "thumbnail",
			index = n1
		})
	end, {})
	local v32 = React.useCallback(function() -- line: 145
		-- upvalues: v27 (copy)
		v27("icon")
	end, {})
	local v33 = React.useCallback(function() -- line: 149
		-- upvalues: v27 (copy)
		v27("empty")
	end, {})
	local v34 = React.useCallback(function(p4) -- line: 153
		-- upvalues: v27 (copy)
		v27(p4)
	end, {})
	local s4 = nil
	local v36 = nil
	local v37 = false

	if v18.kind == "icon" then
		v37 = true
		v36 = icon
		s4 = "image"
	elseif v18.kind == "thumbnail" then
		local v38 = v24[v18.index]

		if v38 then
			s4 = v38.mediaType
			v36 = v38.assetSource
		end
	end

	local v39 = React.useMemo(function() -- line: 174
		-- upvalues: v22 (copy), v26 (copy)
		if not v22 then
			return {{
				items = {}
			}}
		end

		return v26(v22)
	end, {
		v22,
		v26
	})
	local t4 = {}
	local v41 = v20 and v22 == "icon"

	t4.IconSlot = React.createElement(FilmstripSlot, {
		aspectRatio = "square",
		mediaType = "image",
		isFilled = true,
		LayoutOrder = 1,
		assetSource = icon,
		isSelected = v18.kind == "icon",
		isMenuOpen = v41,
		menuItems = if not v41 then nil else v39,
		onMenuActivated = v28,
		onMenuClose = v29,
		onSelect = v30,
		onEditPressed = v32
	})

	for v42, v43 in v24 do
		local id = v43.id
		local v45 = v18.kind == "thumbnail" and v42 == v18.index
		local v46 = v20 and v22 == id

		t4[`Thumb_{ v42 }`] = React.createElement(FilmstripSlot, {
			aspectRatio = "wide",
			isFilled = true,
			mediaType = v43.mediaType,
			assetSource = v43.assetSource,
			isSelected = v45,
			isMenuOpen = v46,
			menuItems = if not v46 then nil else v39,
			onMenuActivated = v28,
			onMenuClose = v29,
			onSelect = function() -- line: 214
				-- upvalues: v31 (copy), v42 (copy)
				v31(v42)
			end,
			onEditPressed = function() -- line: 217
				-- upvalues: v34 (copy), id (copy)
				v34(id)
			end,
			LayoutOrder = v42 + 1
		})
	end

	if v25 then
		local v47 = v20 and v22 == "empty"

		t4.EmptySlot = React.createElement(FilmstripSlot, {
			aspectRatio = "wide",
			mediaType = nil,
			assetSource = nil,
			isFilled = false,
			isSelected = false,
			isMenuOpen = v47,
			menuItems = if not v47 then nil else v39,
			onMenuActivated = v28,
			onMenuClose = v29,
			onSelect = v33,
			onEmptySlotPressed = v33,
			LayoutOrder = #v24 + 2
		})
	end

	local v48 = v14.Size.Size_2400 + 2 * v14.Padding.Medium

	return React.createElement(View, {
		tag = "col gap-xlarge size-full"
	}, {
		Preview = React.createElement(View, {
			tag = "align-x-center align-y-center fill size-full-0 padding-xlarge",
			LayoutOrder = 1
		}, {
			PreviewContent = React.createElement(MediaPreview, {
				mediaType = s4,
				assetSource = v36,
				isIcon = v37
			})
		}),
		Filmstrip = React.createElement(ScrollView, {
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, v48),
			scroll = {
				AutomaticCanvasSize = Enum.AutomaticSize.X,
				CanvasSize = UDim2.new(0, 0, 1, 0),
				ScrollingDirection = Enum.ScrollingDirection.X,
				scrollBarVisibility = Foundation.Enums.Visibility.None
			}
		}, {
			FilmstripContent = React.createElement(View, {
				tag = "row gap-medium auto-xy padding-xlarge"
			}, t4)
		})
	})
end

return IconThumbnailsEditor
