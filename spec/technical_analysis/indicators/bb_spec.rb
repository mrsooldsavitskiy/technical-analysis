require 'technical-analysis'
require 'spec_helper'

RSpec.describe 'Indicators::Bollinger Bands (BB)' do
  let(:input_data) { SpecHelper.get_test_data(:close) }
  let(:indicator) { TechnicalAnalysis::Bb }

  describe 'Bollinger Bands' do
    it 'calculates BB (20, 2)' do
      output = indicator.calculate(input_data, period: 20, standard_deviations: 2, price_key: :close)
      normalized_output = output.map(&:to_hash)

      expected_output = [
        ['2019-01-09', 141.02036711220762, 157.35499999999996, 173.6896328877923],
        ['2019-01-08', 141.07714470666247, 158.1695, 175.26185529333753],
        ['2019-01-07', 141.74551015326722, 159.05649999999997, 176.36748984673272],
        ['2019-01-04', 142.5717393007821, 160.39600000000002, 178.22026069921793],
        ['2019-01-03', 143.53956406332316, 161.8175, 180.09543593667684],
        ['2019-01-02', 145.3682834538487, 163.949, 182.52971654615132],
        ['2018-12-31', 145.53555575730587, 164.98199999999997, 184.42844424269407],
        ['2018-12-28', 145.90334076589886, 166.0725, 186.24165923410112],
        ['2018-12-27', 146.65592111904317, 167.308, 187.96007888095681],
        ['2018-12-26', 148.0390209273478, 168.2125, 188.38597907265222],
        ['2018-12-24', 149.41938426834125, 169.08499999999998, 188.7506157316587],
        ['2018-12-21', 153.6905118237551, 170.35799999999998, 187.02548817624486],
        ['2018-12-20', 157.58081627897096, 171.6605, 185.74018372102907],
        ['2018-12-19', 160.2737711222648, 172.66799999999998, 185.06222887773515],
        ['2018-12-18', 161.48722339827833, 173.91649999999998, 186.34577660172164],
        ['2018-12-17', 160.6411151779543, 175.28949999999995, 189.9378848220456],
        ['2018-12-14', 161.3586392867227, 176.66299999999998, 191.96736071327726],
        ['2018-12-13', 162.73753871102127, 177.72899999999998, 192.7204612889787],
        ['2018-12-12', 162.83769519003326, 178.79299999999998, 194.7483048099667],
        ['2018-12-11', 163.37450359253498, 180.04649999999998, 196.71849640746498],
        ['2018-12-10', 162.797082234342, 181.8385, 200.879917765658],
        ['2018-12-07', 162.2270311355715, 183.783, 205.33896886442847],
        ['2018-12-06', 162.58630667652835, 185.856, 209.12569332347164],
        ['2018-12-04', 163.34919566513827, 187.30850000000004, 211.2678043348618],
        ['2018-12-03', 164.3311203741903, 188.55350000000004, 212.77587962580978],
        ['2018-11-30', 164.11704019466114, 189.68650000000005, 215.25595980533896],
        ['2018-11-29', 163.04822623308377, 191.8685, 220.68877376691626],
        ['2018-11-28', 163.2435966888823, 193.83400000000003, 224.42440331111777],
        ['2018-11-27', 164.31484291109825, 195.45200000000006, 226.58915708890186],
        ['2018-11-26', 167.03813268520582, 197.35200000000003, 227.66586731479424],
        ['2018-11-23', 169.9836589081704, 199.436, 228.8883410918296],
        ['2018-11-21', 173.9574856242928, 201.81150000000002, 229.66551437570726],
        ['2018-11-20', 177.92765761752017, 203.72700000000003, 229.5263423824799],
        ['2018-11-19', 182.16105406114465, 206.0145, 229.86794593885534],
        ['2018-11-16', 185.04223870650642, 207.75399999999996, 230.4657612934935],
        ['2018-11-15', 186.80906188255153, 209.04299999999998, 231.27693811744842],
        ['2018-11-14', 189.47053333403466, 210.27349999999996, 231.07646666596526],
        ['2018-11-13', 193.84357681067348, 211.993, 230.1424231893265],
        ['2018-11-12', 197.38090736241395, 213.48899999999998, 229.597092637586],
        ['2018-11-09', 201.29218743765117, 214.6485, 228.00481256234886],
        ['2018-11-08', 202.68427348053234, 215.5305, 228.37672651946764],
        ['2018-11-07', 203.4002295525166, 215.82850000000002, 228.25677044748343],
        ['2018-11-06', 204.03232701561498, 216.14900000000003, 228.26567298438508],
        ['2018-11-05', 205.76564218562143, 217.30400000000003, 228.84235781437863]
      ].map { |o| { date_time: "#{o[0]}T00:00:00.000Z", lower_band: o[1], middle_band: o[2], upper_band: o[3] } }

      expect(normalized_output).to eq(expected_output)
    end

    it 'throws exception if not enough data' do
      expect { indicator.calculate(input_data, period: input_data.size + 1, price_key: :close) }
        .to raise_exception(TechnicalAnalysis::Validation::ValidationError)
    end

    it 'returns the symbol' do
      expect(indicator.indicator_symbol).to eq('bb')
    end

    it 'returns the name' do
      expect(indicator.indicator_name).to eq('Bollinger Bands')
    end

    it 'returns the valid options' do
      expect(indicator.valid_options).to eq(%i[period standard_deviations price_key])
    end

    it 'validates options' do
      valid_options = { period: 22 }
      expect(indicator.validate_options(valid_options)).to eq(true)
    end

    it 'throws exception for invalid options' do
      invalid_options = { test: 10 }
      expect { indicator.validate_options(invalid_options) }.to raise_exception(TechnicalAnalysis::Validation::ValidationError)
    end

    it 'calculates minimum data size' do
      options = { period: 4 }
      expect(indicator.min_data_size(options)).to eq(4)
    end
  
    it 'performs calculations within acceptable time limit' do
      time_limit = 0.5 # seconds

      execution_time = Benchmark.realtime do
        indicator.calculate(input_data, period: 20, standard_deviations: 2, price_key: :close)
      end

      expect(execution_time).to be < time_limit
    end
  end
end
