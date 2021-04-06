class CaList < ApplicationRecord
    has_many :ca_limits

    def id_list
        return self.ca_limits.pluck(:admin_group_id)
    end

    def name_list
        ids = self.ca_limits.pluck(:admin_group_id)
        ret = []
        ids.each do |i|
            g = AdminGroup.find(i)
            ret.push(g.name)
        end
        return ret
    end
    
end
