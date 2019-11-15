require_relative "bin2/bin2core.rb"
require_relative "bin2/savecore.rb"
require 'pp'
class Mpk
  def initialize(file_name)
    @mpk=Bin2.new(file_name)
  end
  def info(f_id,type="")
    unk0=long
    count=long
    if type == "count"
      @mpk.gotoo(0)
      print count,"\n"
      return count
    end
    pp=[]
    for i in 0...count

      name=strrr_data
      offset=long
      bsize=long
      type_id=long
      if !pp.include?(type_id/2)
        pp[pp.size]=type_id/2
      end
      if (type_id/2) == f_id #and unk1.to_s(16).size == 6
        if type == "export"
          print [offset.to_s(16),bsize.to_s(16),name,(type_id/2).to_s(16)],"\n"
          if bsize != 0
            mq_wz=@mpk.gotoo
            b_name="Resources"+(type_id/2).to_s
            if (type_id/2) == 0
              b_name="Resources"
            end
            print b_name,"\n"

            block_file=Bin2.new(b_name+".mpk")
            block_file.gotoo(offset)
            n_f=Savecore.new(name)
            n_f.write_data block_file.r_data("",bsize)
            block_file.cend
            n_f.cend
            @mpk.gotoo(mq_wz)
          else
            make_floders(name)
          end
        elsif type == "list"
          print name,"\n"
        end
      end
    end
    #print pp,"\n"
  end
  def make_floders(_folder_url)
    n_size=_folder_url.split("/").size
    if n_size != 1
			n_data=_folder_url.split("/")
			url_list=[]
			for i in 0...(n_size-1)
				t_list=[]
				for a in 0..i
					t_list[a]=n_data[a]
				end
				url_list[i]=t_list.join("/")
				make_floder(url_list[i])
			end
			#print url_list,"\n"
		end
  end
  def make_floder(_folder)
  	if File.directory?(_folder)
  	else
  		Dir.mkdir(_folder)
  	end
  end
  def pack0(file_name)
    @i_data=Bin2.new(file_name)
    info_count=info("count")
    @i_data.gotoo(272)
    js=0
    loop do
      break if js==info_count
      strr_infoo=strrr_data20
      js+=1 if /,/ =~ strr_infoo
      pp strr_infoo
    end
  end
  def long
    return @mpk.long
  end
  def strrr_data20
    p=[]
    loop do
      tmp_strr=@i_data.r_data("",1)
      if tmp_strr == "\x20"
        break
      end
      p[p.size]=tmp_strr
    end
    return p.join.to_s
  end
  def strrr_data
    name_size=@mpk.short
    return @mpk.r_data("",name_size)
  end
end

tppp=Mpk.new("Resources.mpkinfo")
tppp.info(ARGV[0].to_i,ARGV[1].to_s)
#tppp.pack0("Resources.mpk")
