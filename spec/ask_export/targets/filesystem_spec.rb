require "tmpdir"

RSpec.describe AskExport::Targets::Filesystem do
  describe "#export" do
    it "saves the file" do
      Dir.mktmpdir do |tmpdir|
        ClimateControl.modify OUTPUT_DIR: tmpdir do
          target = AskExport::Targets::Filesystem.new
          target.export("pipeline-name", "file.csv", "data")

          expect(File).to exist(File.join(tmpdir, "file.csv"))
        end
      end
    end
  end

  describe "#output_directory" do
    it "returns an environment variable value if set" do
      ClimateControl.modify OUTPUT_DIR: "some-folder" do
        dir = AskExport::Targets::Filesystem.output_directory
        expect(dir).to eq("some-folder")
      end
    end

    it "returns an project output folder path if env var not set" do
      dir = AskExport::Targets::Filesystem.output_directory
      expect(dir).to eq(File.expand_path("../../../output", __dir__))
    end
  end
end
