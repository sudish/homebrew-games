require 'formula'

class Cataclysm < Formula
  homepage 'http://www.cataclysmdda.com/'
  url  'https://github.com/CleverRaven/Cataclysm-DDA/archive/0.9.zip'
  sha1 'f2b3540618a901dadf0f8d375f6449365c7bd2ac'
  head 'https://github.com/CleverRaven/Cataclysm-DDA.git'

  option 'with-tiles', 'Include support for graphical tilesets'

  depends_on 'gettext'
  if build.with? 'tiles'
    depends_on 'sdl'
    depends_on 'sdl_image'
    depends_on 'sdl_ttf'
  end

  def install
    cata_options = ['NATIVE=osx', 'RELEASE=1']
    if build.with? 'tiles'
      cata_options << 'TILES=1'
      inreplace 'Makefile' do |s|
        s.change_make_var! 'TILESTARGET', 'cataclysm'
      end
    end

    system 'make', "CXX=#{ENV.cxx}", "LD=#{ENV.cxx}", *cata_options

    # no make install, so we have to do it ourselves
    libexec.install 'cataclysm', 'data', 'gfx'
    inreplace 'cataclysm-launcher' do |s|
      s.change_make_var! 'DIR', libexec
    end
    bin.install 'cataclysm-launcher' => 'cataclysm'
  end
end
