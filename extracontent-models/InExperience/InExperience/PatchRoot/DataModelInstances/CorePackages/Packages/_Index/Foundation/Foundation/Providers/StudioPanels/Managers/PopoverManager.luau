local HttpService = game:GetService("HttpService")
local Foundation = script:FindFirstAncestor("Foundation")
local Flags = require(Foundation.Utility.Flags)
local StudioUri = require(Foundation.Utility.Plugin.StudioUri)

require(script.Parent.Parent.Types)

local function bindToClose(p1, p2: ((...any) -> ...any)) -- line: 19
	if p1:IsA("PluginGui") then
		p1:BindToClose(p2)
	end
end
local function isStrictDescendantOf(t1: {[any]: any}, t2: {[any]: any}, t3: {[any]: any}) -- line: 37
	local parentPopoverId = t3.parentPopoverId

	while parentPopoverId do
		if parentPopoverId == t2.id then
			return true
		end

		local v14 = t1[parentPopoverId]

		if not v14 then
			return false
		end

		parentPopoverId = v14.parentPopoverId
	end

	return false
end

local t4 = {}

t4.__index = t4

function t4.new(p3, s1: string?) -- line: 70
	-- upvalues: t4 (copy), StudioUri (copy)
	local self = setmetatable({}, t4)

	self._uriScope = s1
	self._plugin = p3
	self._panels = p3:GetPluginComponent("Panels")
	self._pluginUri = StudioUri.wrap(p3:GetUri())
	self._active = {}
	self._pool = {}
	self._didPrewarm = false

	return self
end
function t4.openAtAsync(p4, p5, p6: ((...any) -> ...any)?, n1: number?, s2: string?) -- line: 100
	-- upvalues: Flags (copy)
	local v23 = p4:_acquirePanelAsync(p6, if n1 ~= nil then n1 else 0, s2)

	v23.panel.Enabled = false
	p4._panels:SetAttachmentAsync(v23.uri, {
		TargetWidgetUri = p5.targetWidgetUri,
		TargetAnchorPoint = p5.targetAnchorPoint,
		SubjectAnchorPoint = p5.subjectAnchorPoint,
		Offset = p5.offset
	})
	p4._panels:SetSizeAsync(v23.uri, Vector2.new(0, 0))
	v23.panel.Enabled = true
	v23.open = true

	if Flags.FoundationPopoverPluginOverlayMeasurement then
		local generation = v23.generation

		return {
			container = v23.panel,
			popoverId = v23.id,
			setSizeAsync = function(vector2: Vector2) -- line: 130
				-- upvalues: v23 (copy), generation (copy), p4 (copy)
				if v23.generation ~= generation or not v23.open then
					return
				end

				local v88 = math.ceil((math.min(3000, vector2.X)))
				local v89 = math.ceil((math.min(3000, vector2.Y)))

				p4._panels:SetSizeAsync(v23.uri, Vector2.new(v88, v89))
			end,
			updateAsync = function(p7) -- line: 138
				-- upvalues: v23 (copy), generation (copy), p4 (copy)
				if v23.generation ~= generation or (not v23.open or not v23.uri) then
					return
				end

				p4._panels:SetAttachmentAsync(v23.uri, {
					TargetWidgetUri = p7.targetWidgetUri,
					TargetAnchorPoint = p7.targetAnchorPoint,
					SubjectAnchorPoint = p7.subjectAnchorPoint,
					Offset = p7.offset
				})
			end,
			close = function() -- line: 150
				-- upvalues: p4 (copy), v23 (copy), generation (copy)
				p4:_closePopover(v23, true, generation)
			end
		}
	end

	return {
		container = v23.panel,
		popoverId = v23.id,
		setSizeAsync = function(vector2: Vector2) -- line: 158
			-- upvalues: p4 (copy), v23 (copy)
			local v92 = math.ceil((math.min(3000, vector2.X)))
			local v93 = math.ceil((math.min(3000, vector2.Y)))

			p4._panels:SetSizeAsync(v23.uri, Vector2.new(v92, v93))
		end,
		updateAsync = function(p8) -- line: 163
			-- upvalues: v23 (copy), p4 (copy)
			if not v23.uri then
				return
			end

			p4._panels:SetAttachmentAsync(v23.uri, {
				TargetWidgetUri = p8.targetWidgetUri,
				TargetAnchorPoint = p8.targetAnchorPoint,
				SubjectAnchorPoint = p8.subjectAnchorPoint,
				Offset = p8.offset
			})
		end,
		close = function() -- line: 175
			-- upvalues: p4 (copy), v23 (copy)
			p4:_closePopover(v23, true)
		end
	}
end
function t4._createPanelAsync(p9, s3: string, n2: number) -- line: 189
	-- upvalues: StudioUri (copy)
	local v28 = p9._plugin:CreateQWidgetPluginGui(s3, {
		InitialEnabled = true,
		Tooltip = true,
		Transparent = true,
		Resizable = true,
		Id = s3,
		Title = s3,
		ZIndex = n2 + 200
	})

	v28.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	return v28, StudioUri.join(p9._pluginUri, {
		Category = "Panels",
		ItemId = s3
	})
end
function t4._makePopoverId(p10) -- line: 210
	-- upvalues: HttpService (copy)
	return `Popovers{ not p10._uriScope and "" or `/{ p10._uriScope }` }/{ HttpService:GenerateGUID(false) }`
end
function t4._createPopoverAsync(p11, s4: string, n3: number) -- line: 215
	-- upvalues: Flags (copy)
	local v33, v34 = p11:_createPanelAsync(s4, n3)
	local t5 = {
		open = false,
		generation = 0,
		parentPopoverId = nil,
		onClose = nil,
		id = s4,
		uri = v34,
		panel = v33,
		depth = n3
	}

	if v33:IsA("PluginGui") then
		v33:BindToClose(function() -- line: 228
			-- upvalues: Flags (copy), p11 (copy), t5 (copy)
			if Flags.FoundationPopoverPluginOverlayMeasurement then
				p11:_closePopover(t5, false, t5.generation)

				return
			end

			p11:_closePopover(t5)
		end)
	end

	v33.InputBegan:Connect(function(input) -- line: 241
		-- upvalues: t5 (copy), p11 (copy)
		if input.UserInputType == Enum.UserInputType.MouseButton1 and t5.open then
			p11:_closeChildPopovers(t5)
		end
	end)

	return t5
end
function t4._activatePopover(p12, t6: {[any]: any}, p13: ((...any) -> ...any)?, s5: string?) -- line: 250
	-- upvalues: Flags (copy)
	if Flags.FoundationPopoverPluginOverlayMeasurement then
		t6.generation = t6.generation + 1
	end

	t6.onClose = p13
	t6.parentPopoverId = s5
	t6.open = false
	p12._active[t6.id] = t6
end
function t4._tryAcquireFromPool(p14, p15: ((...any) -> ...any)?, n4: number, s6: string?) -- line: 269
	local v44 = p14._pool[n4]
	local v45 = if not v44 then nil else table.remove(v44)

	if not v45 then
		return nil
	end

	p14:_activatePopover(v45, p15, s6)

	return v45
end
function t4._acquirePanelAsync(p16, p17: ((...any) -> ...any)?, n5: number, s7: string?) -- line: 289
	local v50 = p16:_tryAcquireFromPool(p17, n5, s7)

	if v50 then
		return v50
	end

	local v51 = p16:_createPopoverAsync(p16:_makePopoverId(), n5)

	p16:_activatePopover(v51, p17, s7)

	return v51
end
function t4.prewarmPoolAsync(p18, n6: number) -- line: 310
	if p18._didPrewarm then
		return
	end

	for i = 0, math.max(0, n6) do
		if p18._pool[i] == nil then
			p18._pool[i] = {}
		end

		local v55 = p18._pool[i]

		if #v55 == 0 then
			local v56 = p18:_createPopoverAsync(p18:_makePopoverId(), i)

			v56.panel.Enabled = false
			table.insert(v55, v56)
		end
	end

	p18._didPrewarm = true
end
function t4._closeChildPopovers(p19, t7: {[any]: any}) -- line: 336
	local t8 = {}
	local g64 = nil
	local g66 = nil
	local g67 = nil
	local v68 = nil
	local v65 = nil

	for _, v61 in p19._active do
		if not v61.open or v61.id == t7.id then
			continue
		end

		local _active = p19._active
		local parentPopoverId = v61.parentPopoverId

		while true do
			repeat
				if g64 or not parentPopoverId then
					g64 = false
					v65 = false
					g66 = true
				end

				if g66 then
					break
				end

				if parentPopoverId == t7.id then
					g67 = true

					break
				end

				v68 = _active[parentPopoverId]

				if not v68 then
					g64 = true
				end
			until not g64

			if g66 then
				break
			end

			if g67 then
				g67 = false

				break
			end

			parentPopoverId = v68.parentPopoverId
		end

		if not g66 then
			v65 = true
		end

		g66 = false

		if v65 then
			table.insert(t8, v61)
		end
	end

	for _, v70 in t8 do
		p19:_closePopover(v70)
	end
end
function t4._closePopover(p20, t9: {[any]: any}, b1: boolean?, n7: number?) -- line: 362
	-- upvalues: Flags (copy)
	if Flags.FoundationPopoverPluginOverlayMeasurement and (n7 ~= nil and n7 ~= t9.generation) then
		return
	end

	if not t9.open then
		return
	end

	t9.open = false
	t9.panel.Enabled = false

	if not b1 and t9.onClose then
		t9.onClose()
	end

	p20._active[t9.id] = nil

	local depth = t9.depth

	if not p20._pool[depth] then
		p20._pool[depth] = {}
	end

	table.insert(p20._pool[depth], t9)
end
function t4.closeAll(p21) -- line: 396
	local t10 = {}

	for _, v79 in p21._active do
		table.insert(t10, v79)
	end

	for _, v81 in t10 do
		p21:_closePopover(v81)
	end
end
function t4.destroy(p22) -- line: 410
	p22:closeAll()

	for _, v84 in p22._pool do
		for _, v86 in v84 do
			if v86.panel then
				v86.panel:Destroy()
			end
		end
	end

	p22._pool = {}
end

return t4
