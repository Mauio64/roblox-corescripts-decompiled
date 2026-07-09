local Parent = script:FindFirstAncestor("AmpUpsell").Parent
local Promise = require(Parent.Promise)
local t1 = {}

t1.__index = t1

function t1.new() -- line: 12
	-- upvalues: t1 (copy)
	return (setmetatable({}, t1))
end
function t1.registerURL(_: {[any]: any}, _: string) -- line: 16
end
function t1.detectURL(_: {[any]: any}, _: string) -- line: 20
end
function t1.listenForLuaURLs(_: {[any]: any}, _: ((...any) -> ...any)) -- line: 24
end
function t1.stopListeningForLuaURLs(_) -- line: 28
end
function t1.openURL(t5: {[any]: any}, s3: string) -- line: 32
	-- upvalues: Promise (copy)
	t5.lastOpenedURL = s3

	return Promise.resolve(true)
end
function t1.isURLRegistered(_: {[any]: any}, _: string) -- line: 37
	-- upvalues: Promise (copy)
	return Promise.resolve(true)
end

return t1
