local WhatsNew = script:FindFirstAncestor("WhatsNew")
local Enums = require(WhatsNew.Enums)

require(WhatsNew.Types)

local function assertKind(p1, p2, s1: string) -- line: 34
	assert(p2 == p1.kind, `TourTipCta field '{ s1 }' is not defined for kind '{ p1.kind }' (expected '{ p2 }')`)
end

return {
	none = function() -- line: 95
		-- upvalues: Enums (copy)
		return {
			kind = Enums.TourTipCtaKind.None
		}
	end,
	menu = function(p3) -- line: 102
		-- upvalues: Enums (copy)
		return {
			kind = Enums.TourTipCtaKind.Menu,
			menu = p3
		}
	end,
	nested = function(s2: string, s3: string, p4) -- line: 110
		-- upvalues: Enums (copy)
		return {
			kind = Enums.TourTipCtaKind.Nested,
			openActionKey = s2,
			closeActionKey = s3,
			scope = p4
		}
	end,
	wrap = function(p5) -- line: 41
		-- upvalues: Enums (copy)
		return {
			getKind = function(_: {[any]: any}) -- line: 44
				-- upvalues: p5 (copy)
				return p5.kind
			end,
			getMenu = function(_: {[any]: any}) -- line: 48
				-- upvalues: p5 (copy), Enums (copy)
				local v14 = p5
				local Menu = Enums.TourTipCtaKind.Menu

				assert(Menu == v14.kind, `TourTipCta field 'menu' is not defined for kind '{ v14.kind }' (expected '{ Menu }')`)

				return p5.menu
			end,
			setMenu = function(_: {[any]: any}, p6) -- line: 53
				-- upvalues: p5 (copy), Enums (copy)
				local v18 = p5
				local Menu = Enums.TourTipCtaKind.Menu

				assert(Menu == v18.kind, `TourTipCta field 'menu' is not defined for kind '{ v18.kind }' (expected '{ Menu }')`)
				p5.menu = p6
			end,
			getOpenActionKey = function(_: {[any]: any}) -- line: 58
				-- upvalues: p5 (copy), Enums (copy)
				local v21 = p5
				local Nested = Enums.TourTipCtaKind.Nested

				assert(Nested == v21.kind, `TourTipCta field 'openActionKey' is not defined for kind '{ v21.kind }' (expected '{ Nested }')`)

				return p5.openActionKey
			end,
			setOpenActionKey = function(_: {[any]: any}, s4: string) -- line: 63
				-- upvalues: p5 (copy), Enums (copy)
				local v25 = p5
				local Nested = Enums.TourTipCtaKind.Nested

				assert(Nested == v25.kind, `TourTipCta field 'openActionKey' is not defined for kind '{ v25.kind }' (expected '{ Nested }')`)
				p5.openActionKey = s4
			end,
			getCloseActionKey = function(_: {[any]: any}) -- line: 68
				-- upvalues: p5 (copy), Enums (copy)
				local v28 = p5
				local Nested = Enums.TourTipCtaKind.Nested

				assert(Nested == v28.kind, `TourTipCta field 'closeActionKey' is not defined for kind '{ v28.kind }' (expected '{ Nested }')`)

				return p5.closeActionKey
			end,
			setCloseActionKey = function(_: {[any]: any}, s5: string) -- line: 73
				-- upvalues: p5 (copy), Enums (copy)
				local v32 = p5
				local Nested = Enums.TourTipCtaKind.Nested

				assert(Nested == v32.kind, `TourTipCta field 'closeActionKey' is not defined for kind '{ v32.kind }' (expected '{ Nested }')`)
				p5.closeActionKey = s5
			end,
			getScope = function(_: {[any]: any}) -- line: 78
				-- upvalues: p5 (copy), Enums (copy)
				local v35 = p5
				local Nested = Enums.TourTipCtaKind.Nested

				assert(Nested == v35.kind, `TourTipCta field 'scope' is not defined for kind '{ v35.kind }' (expected '{ Nested }')`)

				return p5.scope
			end,
			setScope = function(_: {[any]: any}, p7) -- line: 83
				-- upvalues: p5 (copy), Enums (copy)
				local v39 = p5
				local Nested = Enums.TourTipCtaKind.Nested

				assert(Nested == v39.kind, `TourTipCta field 'scope' is not defined for kind '{ v39.kind }' (expected '{ Nested }')`)
				p5.scope = p7
			end,
			unwrap = function(_: {[any]: any}) -- line: 88
				-- upvalues: p5 (copy)
				return p5
			end
		}
	end
}
