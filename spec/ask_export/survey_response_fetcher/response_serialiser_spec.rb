RSpec.describe AskExport::SurveyResponseFetcher::ResponseSerialiser do
  describe ".call" do
    it "serialises a smart survey response" do
      serialised_response = serialised_survey_response
      expect(described_class.call(smart_survey_row(serialised_response)))
        .to eq(serialised_response)
    end

    it "can serialise a draft smart survey response" do
      options = { question: "Draft question?", environment: :draft }
      expect(described_class.call(smart_survey_row(options)))
        .to match(hash_including(question: "Draft question?"))
    end

    it "copes on a partial response" do
      expect(described_class.call(smart_survey_row(status: "partial")))
        .to match(hash_including(status: "partial",
                                 question: nil))
    end

    it "copes on a disqualified response" do
      expect(described_class.call(smart_survey_row(status: "disqualified")))
        .to match(hash_including(status: "disqualified",
                                 question: nil))
    end

    it "can include a client_id" do
      expect(described_class.call(smart_survey_row(client_id: "947770117.1576778690")))
        .to match(hash_including(client_id: "947770117.1576778690"))
    end

    it "rebrands an incomplete 'complete' response as a partial response" do
      row = smart_survey_row(status: "completed",
                             id: 10,
                             email: nil,
                             phone: nil,
                             share_video: nil)
      result = nil
      warning = "Response 10 has a completed status but has null " \
                "fields: share_video, email, phone\n"
      expect { result = described_class.call(row) }
        .to output(warning).to_stderr
      expect(result).to match(hash_including(status: "partial"))
    end
  end
end
