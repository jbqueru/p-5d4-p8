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

input={}
function input:allbuttons()
	return btn()
end
function input:time()
	return time()
end
function input:init()
	self.wait=true
	self.timerdelay=0.15
	self.bstate={}
	self.transition={}
	self.sequence={}
	self.timerstart={}
	self.semantic={}
	local i
	for i=1,12 do
		add(self.transition,0)
		add(self.sequence,0)
		add(self.timerstart,0)
		add(self.semantic,0)
	end
end
function input:update()
	local allb=self:allbuttons()
	if (self.wait) then
		self.wait = allb!=0
	else
		local i,p,t
		t=self:time()+0.008
		for p = 0,1 do
			for i = 1,6 do
				local b=band(lshr(allb,p*8+i-1),1) != 0
				local ii = p*6+i
				if b and not self.bstate[ii] then
					self.transition[ii]=1
				elseif self.bstate[ii] and not b then
					self.transition[ii]=-1
				else
					self.transition[ii]=0
				end
				self.bstate[ii]=b

--[[
	idle: s=0, t=0. transition: pressed -> recentpressed, s=-1, start timer
	recentpressed: s<0. transition: released -> recentreleased, -s, start timer
		transition: timer -> idle, report s, s=0, start 2x timer
	recentreleased: s>0. transition: pressed -> recentpressed, -s-1, start timer
		transition: timer -> idle, report s, s=0. t=0
	longpress: s=0, t!=0. transition: released -> idle, t=0
		transition: timer -> longpress, report repeat, start timer
]]
				self.semantic[ii]=0
				if self.sequence[ii]==0 and self.timerstart[ii]==0 then -- idle
					if self.transition[ii]==1 then -- pressed
						self.sequence[ii]=-1
						self.timerstart[ii]=t
					end
				elseif self.sequence[ii]<0 then -- recentpressed
					if self.transition[ii]==-1 then -- released
						self.sequence[ii]=-self.sequence[ii]
						self.timerstart[ii]=t
					elseif t-self.timerstart[ii]>=self.timerdelay then -- timer expired
						self.semantic[ii]=self.sequence[i]
						self.sequence[ii]=0
						self.timerstart[ii]=t+self.timerdelay -- make the first repeat take 3x normal
					end
				elseif self.sequence[ii]>0 then -- recentreleased
					if self.transition[ii]==1 then -- pressed
						self.sequence[ii]=-self.sequence[ii]-1
						self.timerstart[ii]=t
					elseif t-self.timerstart[ii]>=self.timerdelay then -- timer expired
						self.semantic[ii]=self.sequence[ii]
						self.sequence[ii]=0
						self.timerstart[ii]=0
					end
				elseif self.sequence[ii]==0 and self.timerstart[ii]!=0 then -- repeating
					if self.transition[ii]==-1 then -- released
						self.timerstart[ii]=0
					elseif t-self.timerstart[ii]>=self.timerdelay then -- timer expired
						self.transition[ii]=2
						self.timerstart[ii]=t
					end
				end
			end
		end
	end
end
function input:state(n)
	return self.bstate[n]
end
function input:pressednow(n)
	return self.transition[n] == 1
end
function input:releasednow(n)
	return self.transition[n] == -1
end
function input:actionnow(n)
	return self.transition[n]>0
end
function input:multinow(n)
	return self.semantic[n]
end
