local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local v4 = Roact.PureComponent:extend("SignalConnection")

v4.validateProps = t.strictInterface({
	callback = t.callback,
	signal = t.table
})

function v4.init(p1) -- line: 13
	p1.connection = nil
end
function v4.render(_) -- line: 25
	return nil
end
function v4.didMount(p3) -- line: 29
	p3.connection = p3.props.signal:connect(p3.props.callback)
end
function v4.didUpdate(p4, p5) -- line: 33
	if p4.props.callback ~= p5.callback or p4.props.signal ~= p5.signal then
		p4.connection:disconnect()
		p4.connection = p4.props.signal:connect(p4.props.callback)
	end
end
function v4.willUnmount(p6) -- line: 40
	if p6.connection then
		p6.connection:disconnect()
		p6.connection = nil
	end
end

return v4
