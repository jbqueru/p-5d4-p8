-- input library

--[[
copyright 2020 jbq

licensed under the apache license, version 2.0 (the "license");
you may not use this file except in compliance with the license.
you may obtain a copy of the license at

    http://www.apache.org/licenses/license-2.0

unless required by applicable law or agreed to in writing, software
distributed under the license is distributed on an "as is" basis,
without warranties or conditions of any kind, either express or implied.
see the license for the specific language governing permissions and
limitations under the license.
]]

input = {}
function input:init()
	wait = true
	buttons = {}
	pressed = {}
	released = {}
end
function input:update()
	if (wait) then
		wait = btn() != 0
	else
		local i
		for i = 1,6 do
			local b = btn(i-1)
			pressed[i] = not buttons[i] and b
			released[i] = buttons[i] and not b
			buttons[i] = b
		end
	end
end
function input:state(n)
	return buttons[n]
end
function input:pressednow(n)
	return pressed[n]
end
function input:releasednow(n)
	return released[n]
end
