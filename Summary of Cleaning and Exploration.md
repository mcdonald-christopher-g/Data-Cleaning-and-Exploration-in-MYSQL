  Since the purpose of this project was to practice my skills in SQL, I decided not to modify the data values in excel before importing the files.
I expected to find duplicates and some extra spaces in the data values when I first looked through the data, but I also encountered some other
issues. 

      1. Excel keeps track of negative dollar amounts using the format (x.xx) whereas SQL uses float values. So, I had to remove the parentheses
      and add the negative.
      
      2. The data in the revenue and profit columns were strings rather than floats, so I had to change the data types of both.

      3. The original formatting of the dates in excel were not in the default format accepted by SQL, so that needed to be fixed.

  After cleaning the data, I joined both tables to see what the data looked like. With the information given, I decided that profit should be
investigated to identify any trends. There were many different perspectives to take since each order had a few different categories (state,
sport, and date were the biggest categories.) Here's what I found:

      1. The orders placed were relatively evenly distributed across the five sports (between 561 and 577 orders).

      2. The states with the most orders were California (344), Texas (317), and Florida (237). Only three other states had over 100 orders.
      
      3. After filtering for states with at least 40 orders placed throughout the year, Massachusetts had the highest average profit per order
      ($143.41) followed by Connecticut ($114.62), then Washington and Kansas ($108.40 each).

      4. The three months with the highest average profit were April ($187.82), May ($161.19), and June ($190.23). These three months also had
      the highest total profit for the year ($41,141.00, $38,847.24, and $42,802.26 respectively).

      5. In June, the highest average profit among all sports was football ($214.00), whereas hockey gave the most total profit ($10,010.28).

      6. November is the only month where the top five sales yielded a profit below $100.00 each (the highest profit in a single order during
      November was $88.44.) The top five orders in every other month with respect to profit were above $120.00.

CONCLUSION AND NEXT STEPS
  The online sales for sports equipment didn't seem to favor any one of the five sports. As well, the states with the highest number of orders
were spread out across the country. Despite some sports being popular during the summer months and others being more popular in the winter months,
the profits were much higher in April, May, and June. However, November's profits were lower than all other months. If I would create some
visualizations for this data, I would further investigate the number of sales and the total profits per state to see if the visuals present any
trends more clearly than the numbers.
