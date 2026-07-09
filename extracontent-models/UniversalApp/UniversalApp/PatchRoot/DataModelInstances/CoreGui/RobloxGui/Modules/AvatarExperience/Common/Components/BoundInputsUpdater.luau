local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local tutils = require(CorePackages.Packages.tutils)
local SetBoundInputs = require(Modules.LuaApp.Actions.SetBoundInputs)
local MaybeClearBoundInputs = require(Modules.LuaApp.Actions.MaybeClearBoundInputs)
local v12 = Roact.PureComponent:extend("BoundInputsUpdater")

v12.validateProps = t.strictInterface({
	focusController = t.table,
	setBoundInputs = t.callback,
	maybeClearBoundInputs = t.callback
})

function v12.disconnectEvent(p1) -- line: 25
	if p1.disconnect ~= nil then
		p1.disconnect()
		p1.disconnect = nil
	end
end
function v12.subscribeEvent(p2) -- line: 32
	-- upvalues: tutils (copy)
	p2.disconnect = p2.props.focusController.subscribeToBoundInputsChanged(function(p3) -- line: 33
		-- upvalues: tutils (copy), p2 (copy)
		if next(p3) ~= nil then
			if not tutils.deepEqual(p3, p2.lastBoundInputs) then
				p2.props.setBoundInputs(p3, p2.props.focusController)
			end

			p2.lastBoundInputs = p3
		end
	end)

	local v16 = p2.props.focusController.getBoundInputs()

	if next(v16) ~= nil then
		p2.props.setBoundInputs(v16, p2.props.focusController)
	end
end
function v12.didMount(p4) -- line: 49
	p4:subscribeEvent()
end
function v12.render(_) -- line: 53
	return nil
end
function v12.didUpdate(p6, p7) -- line: 57
	if p6.props.focusController ~= p7.focusController then
		p6:disconnectEvent()
		p6:subscribeEvent()
	end
end
function v12.willUnmount(p8) -- line: 65
	p8:disconnectEvent()
	p8.props.maybeClearBoundInputs(p8.props.focusController)
end

local u13 = RoactRodux.connect(nil, function(p9) -- line: 70
	-- upvalues: SetBoundInputs (copy), MaybeClearBoundInputs (copy)
	return {
		setBoundInputs = function(p10, p11) -- line: 72
			-- upvalues: p9 (copy), SetBoundInputs (copy)
			p9(SetBoundInputs(p10, p11))
		end,
		maybeClearBoundInputs = function(p12) -- line: 75
			-- upvalues: p9 (copy), MaybeClearBoundInputs (copy)
			p9(MaybeClearBoundInputs(p12))
		end
	}
end)(v12)

return function(p13) -- line: 81
	-- upvalues: RoactGamepad (copy), Roact (copy), u13 (ref), Cryo (copy)
	return RoactGamepad.withFocusController(function(p14) -- line: 82
		-- upvalues: Roact (copy), u13 (ref), Cryo (copy), p13 (copy)
		return Roact.createElement(u13, Cryo.Dictionary.join(p13, {
			focusController = p14
		}))
	end)
end
