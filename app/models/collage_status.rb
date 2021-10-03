class CollageStatus < ApplicationRecord
    validates :collage_name, {presence: true, uniqueness: true}

    def creator
        admins = Admin.where(id: self.creator_id)
        if admins.blank?
            return nil
        else
            return admins.first
        end
    end

    def checker
        admins = Admin.where(id: self.checker_id)
        if admins.blank?
            return nil
        else
            return admins.first
        end
    end
end
