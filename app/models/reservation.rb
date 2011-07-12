class Reservation < ActiveRecord::Base
  
  belongs_to :user
  has_and_belongs_to_many :items
  
  before_validation :calculate_fee
  validate :must_have_one_item
  validate :date_at_least_today
  validate :ensure_duration_positive
  validate :fee_must_be_at_least_1_time
  validate :no_overlap_for_items
  validates_presence_of :start, :end; :fee
  
  #boring validations
  validates_presence_of :firstname 
  #validates_presence_of :lastname, :address, :phone, :email, 
  
  

  
  protected
  
    def duration
      return (self.end-self.start)/60/60/24.ceil.to_i
    end
    
    def date_at_least_today
      errors.add(:start, "must be at least today") if
        self.start < Date.today
    end
    
    def must_have_one_item
      errors.add(:items, "must be selected") if 
        self.items.length < 1
    end 
  
  
    def ensure_duration_positive
      errors.add(:end, "must be after start") if
        duration <= 0
    end
    
    def fee_must_be_at_least_1_time

    end
  
    def calculate_fee
      fee = 0.to_f
      for item in self.items 
        fee = fee+item.price*duration.to_f
      end
    
      self.fee = fee
    
    end
    
    def no_overlap_for_items
      overlap = false
      reservations = Reservation.all
      
      for reservation in reservations
        #puts "A reservation between :"+reservation.start.to_s+" and "+reservation.end.to_s+" with items: "+reservation.items.to_json
        
        #does the reservation being compared have the same item?
        for item in reservation.items
          if self.items.include?(item)
            #puts "Item included!"
            
            #is the included item also in use in the same time?
            
            #starting before and lasting at least partially some time in overlap
            if reservation.start <= self.start and reservation.end >= self.end
              overlap = true
            end
            
            #starting after and lasting at least partially before end
            if reservation.start >= self.start and reservation.end <= self.end
              overlap = true
            end
          end
        end
        

      end
      
      errors.add(:start, "There is a prior reservation for this equipment during this time") if
        overlap == true
        
    end
    
  
end
