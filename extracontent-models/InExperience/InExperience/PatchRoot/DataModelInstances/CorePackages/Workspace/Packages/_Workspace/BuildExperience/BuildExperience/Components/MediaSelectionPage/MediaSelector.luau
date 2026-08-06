local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local Promise = require(BuildExperienceParent.Promise)
local React = require(BuildExperienceParent.React)
local Foundation = require(BuildExperienceParent.Foundation)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local ScrollView = Foundation.ScrollView
local View = Foundation.View
local SignalsReact = require(BuildExperienceParent.SignalsReact)
local getGameMediaStore = require(BuildExperienceParent.DataHydration).Game.getGameMediaStore
local UniverseConfiguration = require(BuildExperienceParent.DataHydration.UniverseConfiguration)
local createGalleryCaptureSource = require(BuildExperienceParent.Moments.createGalleryCaptureSource)
local useTokens = Foundation.Hooks.useTokens
local getGameMediaForUniverse = require(BuildExperience.utils.getGameMediaForUniverse)
local useMediaUpdater = require(BuildExperience.utils.useMediaUpdater)
local uploadCaptureAsync = require(BuildExperience.utils.uploadCaptureAsync)
local getThumbnailUrlAsync = require(BuildExperience.utils.getThumbnailUrlAsync)
local createImageAssetAsync = require(BuildExperience.utils.createImageAssetAsync)
local CaptureSelectionView = require(script.Parent.CaptureSelectionView)
local FilmstripSlot = require(script.Parent.FilmstripSlot)
local MediaPreview = require(script.Parent.MediaPreview)

require(script.Parent.types)

local function IconThumbnailsEditor(t1: {[any]: any}) -- line: 47
	-- upvalues: getGameMediaForUniverse (copy), React (copy), UniverseConfiguration (copy), SignalsReact (copy), useTokens (copy), createGalleryCaptureSource (copy), useMediaUpdater (copy), LocalizationStrings (copy), getGameMediaStore (copy), uploadCaptureAsync (copy), getThumbnailUrlAsync (copy), Promise (copy), createImageAssetAsync (copy), CaptureSelectionView (copy), FilmstripSlot (copy), View (copy), MediaPreview (copy), ScrollView (copy), Foundation (copy)
	local v24 = getGameMediaForUniverse(t1.universeId)
	local v25 = React.useMemo(function() -- line: 49
		-- upvalues: UniverseConfiguration (copy), t1 (copy)
		return UniverseConfiguration.getUniverseConfigurationStore().getAndFetchSummary(t1.universeId)
	end, { t1.universeId })
	local v26 = SignalsReact.useSignalState(v25.data)
	local v27 = if not v26 then nil else tostring(v26.rootPlaceId)
	local v28 = useTokens()
	local v29, v30 = React.useState(v24.icon)
	local v31, v32 = React.useState(v24.thumbnails)
	local v33, v34 = React.useState({
		kind = "icon"
	})
	local v35, v36 = React.useState(false)
	local v37, v38 = React.useState(nil)
	local v39, v40 = React.useState("editor")
	local v41, v42 = React.useState(nil)
	local v43, v44 = React.useState({})
	local v45 = React.useRef(0)
	local v46 = React.useRef(false)
	local v47 = React.useRef(#v24.thumbnails + 1)
	local v48 = React.useRef(nil)

	if v48.current == nil then
		v48.current = createGalleryCaptureSource(nil, nil, { Enum.CaptureType.Screenshot })
	end

	local v49 = React.useRef(v31)

	v49.current = v31
	React.useRef(v29).current = v29

	local v50 = useMediaUpdater()

	React.useEffect(function() -- line: 80
		-- upvalues: v45 (copy), v32 (copy), v24 (copy)
		if v45.current == 0 then
			v32(v24.thumbnails)
		end
	end, { v24.thumbnails })
	React.useEffect(function() -- line: 86
		-- upvalues: v45 (copy), v30 (copy), v24 (copy)
		if v45.current == 0 then
			v30(v24.icon)
		end
	end, { v24.icon })

	local v51 = React.useMemo(function() -- line: 92
		-- upvalues: v31 (copy)
		local t2 = {}

		for _, v86 in v31 do
			table.insert(t2, v86)
		end

		return t2
	end, { v31 })
	local v52 = v27 ~= nil
	local v53 = #v51 < 10 and v52
	local v54 = React.useCallback(function(s1: string, b1: boolean) -- line: 103
		-- upvalues: v44 (copy)
		v44(function(p1) -- line: 104
			-- upvalues: s1 (copy), b1 (copy)
			local v115 = table.clone(p1)

			v115[s1] = not not b1 or nil

			return v115
		end)
	end, {})
	local v55 = React.useCallback(function() -- line: 111
		-- upvalues: v45 (copy)
		local v89 = v45

		v89.current = v89.current + 1
	end, {})
	local v56 = React.useCallback(function() -- line: 115
		-- upvalues: v45 (copy)
		v45.current = math.max(0, v45.current - 1)
	end, {})
	local v57 = React.useCallback(function(s2: string) -- line: 119
		-- upvalues: v52 (copy), LocalizationStrings (copy)
		local t3 = {}

		if v52 then
			table.insert(t3, {
				id = "capture_library",
				icon = "icons/common/image",
				text = LocalizationStrings.MEDIA_SELECTION_CAPTURE_LIBRARY
			})
		end

		if s2 ~= "icon" and s2 ~= "thumbnail_1" and s2 ~= "empty" then
			table.insert(t3, {
				id = "delete",
				icon = "icons/common/trash",
				text = LocalizationStrings.MEDIA_SELECTION_DELETE
			})
		end

		return {{
			items = t3
		}}
	end, { v52 })
	local v58 = React.useCallback(function(s3: string) -- line: 140
		-- upvalues: v43 (copy), v46 (copy), v38 (copy), v36 (copy)
		if v43[s3] or v46.current and s3 ~= "icon" and s3 ~= "empty" then
			return
		end

		v38(s3)
		v36(true)
	end, { v43 })
	local v59 = React.useCallback(function(s4: string) -- line: 149
		-- upvalues: v36 (copy), v46 (copy), v37 (copy), v52 (copy), v42 (copy), v40 (copy), v27 (copy), v43 (copy), v31 (copy), v55 (copy), v54 (copy), v32 (copy), v33 (copy), v34 (copy), v50 (copy), getGameMediaStore (copy), t1 (copy), v56 (copy)
		v36(false)

		if v46.current and (v37 ~= "icon" and v37 ~= "empty") then
			return
		end

		if s4 == "capture_library" and v52 then
			v42(v37)
			v40("captureSelection")

			return
		end

		if s4 == "delete" then
			local v94 = v37

			if v94 == nil or v27 == nil or v43[v94] then
				return
			end

			local u95 = nil
			local v96 = nil

			for v97, v98 in v31 do
				if v94 == v98.id then
					u95 = v97
					v96 = v98

					break
				end
			end

			if u95 == nil or v96 == nil then
				return
			end

			local v99 = v96

			if not v99.assetResourceName then
				return
			end

			local assetResourceName = v99.assetResourceName

			v46.current = true
			v55()
			v54(v94, true)
			v32(function(p2) -- line: 185
				-- upvalues: v94 (copy)
				local t4 = {}

				for _, v119 in p2 do
					if v119.id ~= v94 then
						table.insert(t4, v119)
					end
				end

				return t4
			end)

			if v33.kind == "thumbnail" and v94 == v33.id then
				v34({
					kind = "icon"
				})
			end

			v50.removePreview(v27, assetResourceName):andThen(function() -- line: 200
				-- upvalues: getGameMediaStore (copy), t1 (copy)
				getGameMediaStore().fetchGameMedia((tostring(t1.universeId)))
			end):catch(function() -- line: 203
				-- upvalues: v32 (copy), v94 (copy), u95 (ref), v99 (copy)
				v32(function(p3) -- line: 204
					-- upvalues: v94 (copy), u95 (ref), v99 (copy)
					for _, v135 in p3 do
						if v135.id == v94 then
							return p3
						end
					end

					local v136 = table.clone(p3)

					table.insert(v136, math.min(u95, #v136 + 1), v99)

					return v136
				end)
			end):finally(function() -- line: 215
				-- upvalues: v46 (copy), v54 (copy), v94 (copy), v56 (copy)
				v46.current = false
				v54(v94, false)
				v56()
			end)
		end
	end, {
		v37,
		v33,
		v31,
		v50,
		v27,
		v52,
		v43,
		v55,
		v56,
		v54
	})
	local v60 = React.useCallback(function() -- line: 236
		-- upvalues: v36 (copy)
		v36(false)
	end, {})
	local v61 = React.useCallback(function() -- line: 240
		-- upvalues: v34 (copy)
		v34({
			kind = "icon"
		})
	end, {})
	local v62 = React.useCallback(function(s5: string) -- line: 244
		-- upvalues: v34 (copy)
		v34({
			kind = "thumbnail",
			id = s5
		})
	end, {})
	local v63 = React.useCallback(function() -- line: 248
		-- upvalues: v58 (copy)
		v58("icon")
	end, { v58 })
	local v64 = React.useCallback(function() -- line: 252
		-- upvalues: v58 (copy)
		v58("empty")
	end, { v58 })
	local v65 = React.useCallback(function(p4) -- line: 256
		-- upvalues: v58 (copy)
		v58(p4)
	end, { v58 })
	local v66 = React.useCallback(function(p5) -- line: 261
		-- upvalues: v41 (copy), v27 (copy), v43 (copy), v40 (copy), v42 (copy), v49 (copy), v47 (copy), v55 (copy), v54 (copy), v34 (copy), v32 (copy), uploadCaptureAsync (copy), getThumbnailUrlAsync (copy), Promise (copy), v26 (copy), createImageAssetAsync (copy), v50 (copy), v30 (copy), getGameMediaStore (copy), t1 (copy), v56 (copy)
		local v104 = v41

		if v104 == nil or (v27 == nil or v43[v104]) then
			return
		end

		v40("editor")
		v42(nil)

		local v105 = nil
		local u106 = nil

		if v104 ~= "icon" and v104 ~= "empty" then
			for v107, v108 in v49.current do
				if v104 == v108.id then
					v105 = v107
					u106 = v108

					break
				end
			end

			if v105 == nil or u106 == nil then
				return
			end

			if not u106.assetResourceName then
				return
			end
		end

		local u109

		if v104 == "empty" then
			u109 = `thumbnail_pending_{ v47.current }`

			local v110 = v47

			v110.current = v110.current + 1
		else
			u109 = v104
		end

		v55()
		v54(u109, true)

		if v104 == "icon" then
			v34({
				kind = "icon"
			})
		elseif v104 == "empty" then
			v32(function(p6) -- line: 302
				-- upvalues: u109 (ref)
				local v121 = table.clone(p6)

				table.insert(v121, {
					mediaType = "image",
					assetSource = nil,
					id = u109
				})

				return v121
			end)
			v34({
				kind = "thumbnail",
				id = u109
			})
		else
			v32(function(p7) -- line: 313
				-- upvalues: v104 (copy)
				local v123 = table.clone(p7)

				for v124, v125 in v123 do
					if v125.id == v104 then
						v123[v124] = {
							mediaType = "image",
							assetSource = nil,
							id = v125.id
						}

						return v123
					end
				end

				return v123
			end)
		end

		local v111 = uploadCaptureAsync(p5):andThen(function(p8) -- line: 330
			-- upvalues: getThumbnailUrlAsync (copy)
			return getThumbnailUrlAsync(p8.assetId)
		end):andThen(function(p9) -- line: 333
			-- upvalues: Promise (copy), v26 (copy), createImageAssetAsync (copy), v104 (copy)
			if typeof(p9) == "table" and p9.status == "in_review" then
				return Promise.reject({
					code = "IN_REVIEW",
					message = "Capture is under moderation review"
				})
			end

			local imageUrl = p9.imageUrl
			local v129 = if not v26 then nil else {
				creatorType = v26.creatorType,
				creatorTargetId = v26.creatorTargetId
			}

			return createImageAssetAsync(imageUrl, nil, v104 == "icon", v129):andThen(function(p10) -- line: 347
				-- upvalues: imageUrl (copy)
				return {
					imageAssetId = tostring(p10.assetId),
					displayUrl = imageUrl
				}
			end)
		end)
		local v112 = v111:andThen(function(p11) -- line: 355
			return p11.imageAssetId
		end);

		((if v104 ~= "icon" then (if v104 ~= "empty" then v50.replacePreview(v27, v112, u106.assetResourceName) else v50.addPreview(v27, v112)) else v50.setIcon(v27, v112))):andThen(function() -- line: 373
			-- upvalues: v111 (copy)
			return v111
		end):andThen(function(t5: {[any]: any}) -- line: 376
			-- upvalues: v104 (copy), v30 (copy), v32 (copy), u109 (ref), getGameMediaStore (copy), t1 (copy)
			if v104 == "icon" then
				v30(t5.displayUrl)
			else
				v32(function(p12) -- line: 380
					-- upvalues: u109 (ref), t5 (copy)
					local v139 = table.clone(p12)

					for v140, v141 in v139 do
						if v141.id == u109 then
							v139[v140] = {
								mediaType = "image",
								id = u109,
								assetSource = t5.displayUrl,
								assetResourceName = `assets/{ t5.imageAssetId }`
							}

							return v139
						end
					end

					return v139
				end)
			end

			getGameMediaStore().fetchGameMedia((tostring(t1.universeId)))
		end):catch(function() -- line: 398
			-- upvalues: v104 (copy), v32 (copy), u109 (ref), v34 (copy), u106 (ref)
			if v104 == "icon" then
				return
			end

			if v104 == "empty" then
				v32(function(p13) -- line: 402
					-- upvalues: u109 (ref)
					local t6 = {}

					for _, v145 in p13 do
						if v145.id ~= u109 then
							table.insert(t6, v145)
						end
					end

					return t6
				end)
				v34(function(p14) -- line: 411
					-- upvalues: u109 (ref)
					if p14.kind == "thumbnail" and p14.id == u109 then
						return {
							kind = "icon"
						}
					end

					return p14
				end)

				return
			end

			local v132 = u106

			v32(function(p15) -- line: 418
				-- upvalues: u109 (ref), v132 (copy)
				local v148 = table.clone(p15)

				for v149, v150 in v148 do
					if v150.id == u109 then
						v148[v149] = v132

						return v148
					end
				end

				return v148
			end)
		end):finally(function() -- line: 430
			-- upvalues: v54 (copy), u109 (ref), v56 (copy)
			v54(u109, false)
			v56()
		end)
	end, {
		v41,
		v50,
		v27,
		v26,
		v43,
		v55,
		v56,
		v54
	})
	local v67 = React.useCallback(function() -- line: 447
		-- upvalues: v40 (copy), v42 (copy)
		v40("editor")
		v42(nil)
	end, {})

	React.useEffect(function() -- line: 452
		-- upvalues: t1 (copy), v39 (copy), v67 (copy)
		local backHandlerRef = t1.backHandlerRef

		if backHandlerRef then
			backHandlerRef.current = if v39 ~= "captureSelection" then nil else v67
		end

		return function() -- line: 457
			-- upvalues: backHandlerRef (copy)
			if backHandlerRef then
				backHandlerRef.current = nil
			end
		end
	end, {
		v39,
		v67
	})

	local v68 = React.useMemo(function() -- line: 464
		-- upvalues: v37 (copy), v57 (copy)
		if not v37 then
			return {{
				items = {}
			}}
		end

		return v57(v37)
	end, {
		v37,
		v57
	})

	if v39 == "captureSelection" then
		return (React.createElement(CaptureSelectionView, {
			captureSource = v48.current,
			onCaptureConfirmed = v66
		}))
	end

	local s6 = nil
	local v70 = nil
	local v71 = false
	local v72 = false

	if v33.kind == "icon" then
		v71 = true
		v70 = v29
		s6 = "image"
		v72 = v43.icon or false
	elseif v33.kind == "thumbnail" then
		for _, v74 in v51 do
			if v74.id == v33.id then
				s6 = v74.mediaType
				v70 = v74.assetSource
				v72 = v43[v74.id] or false

				break
			end
		end
	end

	local t7 = {}
	local v76 = v35 and v37 == "icon"

	t7.IconSlot = React.createElement(FilmstripSlot, {
		aspectRatio = "square",
		mediaType = "image",
		isFilled = true,
		LayoutOrder = 1,
		assetSource = v29,
		isSelected = v33.kind == "icon",
		isLoading = v43.icon or false,
		isMenuOpen = v76,
		menuItems = if not v76 then nil else v68,
		onMenuActivated = v59,
		onMenuClose = v60,
		onSelect = v61,
		onEditPressed = if not v52 then nil else v63
	})

	for v77, v78 in v51 do
		local id = v78.id
		local v80 = v33.kind == "thumbnail" and id == v33.id
		local v81 = v35 and v37 == id

		t7[`Thumb_{ v77 }`] = React.createElement(FilmstripSlot, {
			aspectRatio = "wide",
			isFilled = true,
			mediaType = v78.mediaType,
			assetSource = v78.assetSource,
			isSelected = v80,
			isLoading = v43[id] or false,
			isMenuOpen = v81,
			menuItems = if not v81 then nil else v68,
			onMenuActivated = v59,
			onMenuClose = v60,
			onSelect = function() -- line: 534
				-- upvalues: v62 (copy), id (copy)
				v62(id)
			end,
			onEditPressed = if not v52 and id == "thumbnail_1" then nil else function() -- line: 538
				-- upvalues: v65 (copy), id (copy)
				v65(id)
			end,
			LayoutOrder = v77 + 1
		})
	end

	if v53 then
		local v82 = v35 and v37 == "empty"

		t7.EmptySlot = React.createElement(FilmstripSlot, {
			aspectRatio = "wide",
			mediaType = nil,
			assetSource = nil,
			isFilled = false,
			isSelected = false,
			isMenuOpen = v82,
			menuItems = if not v82 then nil else v68,
			onMenuActivated = v59,
			onMenuClose = v60,
			onSelect = v64,
			onEmptySlotPressed = v64,
			LayoutOrder = #v51 + 2
		})
	end

	local v83 = v28.Size.Size_2400 + 2 * v28.Padding.Medium

	return React.createElement(View, {
		tag = "col gap-xlarge size-full"
	}, {
		Preview = React.createElement(View, {
			tag = "align-x-center align-y-center fill size-full-0 padding-xlarge",
			LayoutOrder = 1
		}, {
			PreviewContent = React.createElement(MediaPreview, {
				mediaType = s6,
				assetSource = v70,
				isIcon = v71,
				isLoading = v72
			})
		}),
		Filmstrip = React.createElement(ScrollView, {
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, v83),
			scroll = {
				AutomaticCanvasSize = Enum.AutomaticSize.X,
				CanvasSize = UDim2.new(0, 0, 1, 0),
				ScrollingDirection = Enum.ScrollingDirection.X,
				scrollBarVisibility = Foundation.Enums.Visibility.None
			}
		}, {
			FilmstripContent = React.createElement(View, {
				tag = "row gap-medium auto-xy padding-xlarge"
			}, t7)
		})
	})
end

return IconThumbnailsEditor
