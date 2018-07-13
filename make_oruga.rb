#!/usr/bin/env ruby
# coding: utf-8

require 'digest/md5'
require 'mini_magick'
require 'time'
include MiniMagick


$point_list =[
["00",337,67],
["01",337,67],
["02",352,73],
["03",341,82],
["04",340,80],
["05",332,79],
["06",318,72],
["07",306,66],
["08",305,74],
["09",313,77],
["10",316,80]]

def make_oruga face_path
  img_list =[]
  face = Image.open(face_path)
  to_x = 80
  to_y = 90
  if face.width < face.height then
# 縦長なら
    to_y = to_x * (face.height/face.width) 
  else 
# 横長なら
    to_x = to_y * (face.width/face.height) 
  end
  face.resize("#{to_x}x#{to_y}")
  $point_list.each do |d|
    print "/"
    img = Image.open("./pic/#{d[0]}.png")
    res = img.composite(face) do |c|
      c.compose("Over")
      x = d[1] - face.width/2
      y = d[2] - face.height/2 - 10
      c.geometry("+#{x}+#{y}")
    end
    img_list << res.dup
  end
  img_list.each_with_index do |i,idx|
    i.write("output#{format("%02d",idx)}.png") 
  end

  time = Time.now
  tmp_name = Digest::MD5.hexdigest(time.iso8601(6))

  system "convert -layers optimize -delay 5 -loop 0 output*.png #{tmp_name}.gif"
  system "rm output*"
  new_name = Digest::MD5.file("#{tmp_name}.gif").to_s+".gif"
  system "mv #{tmp_name}.gif #{new_name}"
  puts "make #{new_name}"
  return new_name
end

make_oruga ARGV[0]
