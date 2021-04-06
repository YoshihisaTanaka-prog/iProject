class CaList < ApplicationRecord
    has_many :ca_limits

    def id_list
        return self.ca_limits.pluck(:admin_group_id)
    end

    def name_list
        if self.is_only_admin
            return ["最高権限のみ"]
        end
        if self.is_only_subadmin
            return ["準最高権限以上のみ"]
        end
        if self.is_only_level
            return ["権限レベルによる制限のみ"]
        end
        ids = self.ca_limits.pluck(:admin_group_id)
        ret = []
        ids.each do |i|
            g = AdminGroup.find(i)
            ret.push(g.name)
        end
        return ret
    end
    
end
