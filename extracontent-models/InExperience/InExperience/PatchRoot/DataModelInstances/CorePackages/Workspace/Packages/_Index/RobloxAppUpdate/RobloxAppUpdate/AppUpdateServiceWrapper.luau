local Parent = script:FindFirstAncestor("RobloxAppUpdate").Parent
local Promise = require(Parent.Promise)
local t1 = {}

t1.__index = t1

function t1.new(p1) -- line: 9
	-- upvalues: t1 (copy)
	local t2 = {
		_appUpdate = p1
	}

	setmetatable(t2, t1)

	return t2
end
function t1.checkForUpdate(p2) -- line: 18
	-- upvalues: Promise (copy)
	return Promise.new(function(resolve, _) -- line: 19
		-- upvalues: p2 (copy)
		local ok, result = pcall(function() -- line: 20
			-- upvalues: p2 (copy), resolve (copy)
			p2._appUpdate:CheckForUpdate(function(p4) -- line: 21
				-- upvalues: resolve (copy)
				resolve({
					appUpdateStatus = p4
				})
			end)
		end)

		if not ok then
			resolve({
				errorMessage = result
			})
		end
	end)
end
function t1.performManagedUpdate(p5) -- line: 36
	p5._appUpdate:PerformManagedUpdate()
end
function t1.canPerformBinaryUpdate(p6) -- line: 40
	return p6._appUpdate:CanPerformBinaryUpdate()
end

return t1
