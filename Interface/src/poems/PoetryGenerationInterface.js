import React, { useState } from 'react';
import { Card } from '@/components/ui/card';
import { ChevronRight, ChevronLeft, Camera, Book, X, ArrowLeft, Pen, Wrench } from 'lucide-react';

// Import your backend generation logic
import { deployment_inference } from 'your-backend-file-path'; // Ensure you replace this with the correct import path

const topics = ['صبر', 'حكمة', 'وطن', 'حب', 'دين', 'جمال'];

const PoetryGenerationInterface = () => {
    const [currentStep, setCurrentStep] = useState(0);
    const [selectedTask, setSelectedTask] = useState(null);
    const [uploadedImage, setUploadedImage] = useState(null);
    const [selectedTopic, setSelectedTopic] = useState(null);
    const [showTopics, setShowTopics] = useState(false);
    const [verses, setVerses] = useState(5);
    const [style, setStyle] = useState('طويل');
    const [generatedPoem, setGeneratedPoem] = useState('');
    const [originalPoem, setOriginalPoem] = useState('');
    const [fixedPoem, setFixedPoem] = useState('');
    const [uploadCount, setUploadCount] = useState(0);
    const [caption, setCaption] = useState('');
    const [isProcessing, setIsProcessing] = useState(false);
    const [isGenerating, setIsGenerating] = useState(false);

    const handleTaskSelection = (task) => {
        setSelectedTask(task);
        setCurrentStep(1);
        setShowTopics(false);
    };

    const handleImageUpload = (event) => {
        if (event.target.files[0]) {
            const imageUrl = URL.createObjectURL(event.target.files[0]);
            setUploadedImage(imageUrl);
            setUploadCount(uploadCount + 1);
        }
    };

    const handleTopicSelect = (topic) => {
        if (!uploadedImage) {
            setSelectedTopic(topic);
            setShowTopics(false);
        }
    };

    const handleTopicButtonClick = () => {
        if (!uploadedImage) {
            setShowTopics(!showTopics);
        }
    };

    const handleNext = () => {
        if ((selectedTopic || uploadedImage) && currentStep === 1) {
            setCurrentStep(2);
        } else if (currentStep < 3) {
            setCurrentStep(currentStep + 1);
        }
    };

    const handleBack = () => {
        if (currentStep > 0) {
            setCurrentStep(currentStep - 1);
            setShowTopics(false);
        }
    };

    const handleReset = () => {
        setCurrentStep(0);
        setSelectedTask(null);
        setUploadedImage(null);
        setSelectedTopic(null);
        setShowTopics(false);
        setGeneratedPoem('');
        setOriginalPoem('');
        setFixedPoem('');
        setUploadCount(0);
        setCaption('');
        setIsProcessing(false);
    };

    const generatePoem = async () => {
        setIsGenerating(true);
        try {
            // Replace hardcoded generation with dynamic API call
            const response = await deployment_inference.generate("اكتب شعر");
            const generatedText = response.data?.text || "لم يتم توليد النص. حاول مرة أخرى.";
            setGeneratedPoem(generatedText);
        } catch (error) {
            console.error("خطأ في توليد الشعر:", error);
            setGeneratedPoem("حدث خطأ أثناء توليد الشعر. الرجاء المحاولة مرة أخرى.");
        }
        setIsGenerating(false);
    };

    const renderGeneratedPoem = () => (
        <div className="space-y-6 w-full max-w-2xl mx-auto">
            <div className="bg-white/10 rounded-lg p-6 min-h-[300px] text-white text-right">
                {isGenerating ? 'جاري توليد القصيدة...' : generatedPoem || 'القصيدة ستظهر هنا...'}
            </div>
            {!isGenerating && (
                <div className="flex justify-center gap-4">
                    <button
                        onClick={() => generatePoem()}
                        className="px-6 py-2 rounded-lg bg-purple-500/50 text-white hover:bg-purple-500/70 transition-colors"
                    >
                        توليد القصيدة
                    </button>
                    <button className="px-6 py-2 rounded-lg bg-white/20 text-white hover:bg-white/30 transition-colors">
                        نسخ
                    </button>
                </div>
            )}
        </div>
    );

    const renderCurrentStep = () => {
        switch (currentStep) {
            case 0:
                return renderTaskSelection();
            case 1:
                return selectedTask === 'fix' ? renderFixPoem() : renderInputSelection();
            case 2:
                return renderPoemSettings();
            case 3:
                return renderGeneratedPoem();
            default:
                return null;
        }
    };

    return (
        <div className="min-h-screen bg-gradient-to-b from-purple-900 to-gray-900 p-6 flex items-center justify-center">
            <Card className="w-full max-w-4xl bg-black/30 backdrop-blur-sm border-white/10 p-8 relative">
                <h1 className="text-3xl font-bold text-white text-center mb-12">مولد القصائد العربية</h1>

                {renderCurrentStep()}

                {selectedTask !== 'fix' && (
                    <div className="flex justify-between mt-8">
                        {currentStep > 0 && (
                            <button
                                onClick={handleBack}
                                className="flex items-center gap-2 text-white hover:text-purple-300"
                            >
                                <ChevronRight className="w-5 h-5" />
                                السابق
                            </button>
                        )}

                        {currentStep < 3 && (
                            <button
                                onClick={handleNext}
                                disabled={currentStep === 1 && !selectedTopic && !uploadedImage}
                                className={`flex items-center gap-2 ${currentStep === 1 && !selectedTopic && !uploadedImage
                                        ? 'text-gray-500 cursor-not-allowed'
                                        : 'text-white hover:text-purple-300'
                                    } mr-auto`}
                            >
                                التالي
                                <ChevronLeft className="w-5 h-5" />
                            </button>
                        )}
                    </div>
                )}

                {currentStep > 0 && (
                    <button
                        onClick={handleReset}
                        className="absolute top-4 left-4 text-white hover:text-purple-300 flex items-center gap-2"
                    >
                        <ArrowLeft className="w-5 h-5" />
                        العودة للرئيسية
                    </button>
                )}
            </Card>
        </div>
    );
};

export default PoetryGenerationInterface;
