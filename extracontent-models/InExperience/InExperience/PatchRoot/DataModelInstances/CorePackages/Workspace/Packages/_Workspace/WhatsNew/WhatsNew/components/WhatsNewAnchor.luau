local WhatsNew = script:FindFirstAncestor("WhatsNew")
local WhatsNewParent = WhatsNew.Parent
local Foundation = require(WhatsNewParent.Foundation)
local React = require(WhatsNewParent.React)
local GetWhatsNewStore = require(WhatsNew.store.GetWhatsNewStore)
local View = Foundation.View

local function isGuiObjectReady(p1) -- line: 26
	local AbsoluteSize = p1.AbsoluteSize

	return AbsoluteSize.X > 0 and AbsoluteSize.Y > 0
end
local function WhatsNewAnchor(t1: {[any]: any}) -- line: 31
	-- upvalues: GetWhatsNewStore (copy), React (copy), View (copy)
	local v12 = GetWhatsNewStore()
	local anchorId = t1.anchorId
	local v14 = React.useRef(nil)
	local v15 = React.useCallback(function(p2) -- line: 36
		-- upvalues: v12 (copy), anchorId (copy)
		if p2 == nil then
			return
		end

		local setAnchorReady = v12.setAnchorReady
		local v20 = anchorId
		local AbsoluteSize = p2.AbsoluteSize

		setAnchorReady(v20, AbsoluteSize.X > 0 and AbsoluteSize.Y > 0, p2)
	end, {
		v12,
		anchorId
	})
	local v16 = React.useCallback(function(p3) -- line: 43
		-- upvalues: v14 (copy), v12 (copy), anchorId (copy), v15 (copy)
		if p3 == nil then
			local current = v14.current

			v14.current = nil

			if current ~= nil then
				v12.unregisterAnchor(anchorId, current)
			end

			return
		end

		v14.current = p3
		v12.registerAnchor(anchorId, p3)

		if p3 == v12.getAnchorRef(anchorId) then
			v15(p3)
		end
	end, {
		v12,
		anchorId,
		v15
	})

	React.useEffect(function() -- line: 59
		-- upvalues: v12 (copy), anchorId (copy), v14 (copy)
		return function() -- line: 60
			-- upvalues: v12 (copy), anchorId (copy), v14 (copy)
			v12.unregisterAnchor(anchorId, v14.current)
		end
	end, {
		v12,
		anchorId
	})

	local v17 = React.useCallback(function(p4) -- line: 65
		-- upvalues: v15 (copy)
		v15(p4)
	end, { v15 })

	return React.createElement(View, {
		ref = v16,
		tag = t1.tag or "size-full-0 auto-y",
		LayoutOrder = t1.LayoutOrder,
		onAbsoluteSizeChanged = v17
	}, t1.children)
end

return React.memo(WhatsNewAnchor)
