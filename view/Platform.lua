require 'libs/middleclass'

require 'view/Animation'
require 'view/Image'

Platform = class( 'Platform', Image )

Platform.static.STATIC 				= 1
Platform.static.BOUNCING			= 2
Platform.static.CLEANING			= 3
Platform.static.ENDING				= 4
Platform.static.MOVING_H			= 5
Platform.static.MOVING_V			= 6
Platform.static.SLIPPING			= 7
Platform.static.STICKING			= 8
Platform.static.TELEPORTING			= 9

Platform.static.MOVING_H_BOUNCING	= 10
Platform.static.MOVING_V_BOUNCING	= 11
Platform.static.MOVING_H_SLIPPING	= 12
Platform.static.MOVING_V_SLIPPING	= 13

function Platform:initialize( x, y, mode, world, width, height )
	Image.initialize( self, x, y, width, height, 'images/platform.png' )

	self.scaleX = self.width / self._image:getWidth()
	self.scaleY = self.height / self._image:getHeight()

	local types = {
		'static',
		'bouncing',
		'cleaning',
		'ending',
		'moving-h',
		'moving-v',
		'slipping',
		'sticking',
		'teleporting',
		'moving-h-bouncing',
		'moving-v-bouncing',
		'moving-h-slipping',
		'moving-v-slipping'
	}

	self.updates = {
		--	STATIC
		function() return types[ self:getMode() ] end,
		--	BOUNCING
		function() return types[ self:getMode() ] end,
		--	CLEANING
		function() return types[ self:getMode() ] end,
		--	ENDING
		function() return types[ self:getMode() ] end,
		--	MOVING_H
		function() return types[ self:getMode() ] end,
		--	MOVING_V
		function() return types[ self:getMode() ] end,
		--	SLIPPING
		function() return types[ self:getMode() ] end,
		--	STICKING
		function() return types[ self:getMode() ] end,
		--	TELEPORTING
		function() return types[ self:getMode() ] end,
		--	MOVING_H_BOUNCING
		function() return types[ self:getMode() ] end,
		--	MOVING_V_BOUNCING
		function() return types[ self:getMode() ] end,
		--	MOVING_H_SLIPPING
		function() return types[ self:getMode() ] end,
		--	MOVING_V_BOUNCING
		function() return types[ self:getMode() ] end
	}

	self:setMode( mode or Platform.STATIC )

	self.door = nil

	if self:getMode() == Platform.ENDING then
		self.door = Animation:new( self.x + (self.width * 0.5) - 103, self.y - 413, 206, 413, 'images/door.png', 206, 413, 0 )
		self.door:seek( 1 )
		self.door:stop()
		self.door.scaleX = self.scaleX
		self.door.scaleY = self.scaleY
	end

	local bodyType = 'static'
	if self.mode == 5 or self.mode == 6 or self.mode > 9 then
		bodyType = 'dynamic'
	end

	self.world = world
	self.body = love.physics.newBody( self.world, self.x + (self.width * 0.5), self.y + (self.height * 0.5), 'static' )
	self.shape = love.physics.newRectangleShape( 0, 0, self.width, self.height )
	self.fixture = love.physics.newFixture( self.body, self.shape, 5 )
	self.fixture:setUserData( 'platform-' .. types[ self:getMode() ] )

	if self.mode == 2 or self.mode == 10 or self.mode == 11 then
		self.fixture:setRestitution( 1.0 )
	elseif self.mode == 7 or self.mode > 11 then
		--	
	else
		--	
	end
end

function Platform:update( dt )
	Image.update( self, dt )

	if self.door ~= nil then
		self.door:update( dt )
	end

	self.updates[ self:getMode() ]()
end

function Platform:draw()
	love.graphics.setColor( 255, 255, 255, 255 )
	Image.draw( self )

	if self.door ~= nil then
		self.door:draw()
	end

	if self.mode == 2 or self.mode == 10 or self.mode == 11 then
		love.graphics.setColor( 0, 255, 0, 255 )
	elseif self.mode == 7 or self.mode > 11 then
		love.graphics.setColor( 0, 0, 255, 255 )
	elseif self.mode == 8 then
		love.graphics.setColor( 255, 255, 0, 255 )
	else
		love.graphics.setColor( 255, 0, 0, 255 )
	end
	love.graphics.polygon( 'fill', self.body:getWorldPoints( self.shape:getPoints() ) )
end

function Platform:setMode( mode )
	self.mode = mode
end

function Platform:getMode()
	return self.mode
end
