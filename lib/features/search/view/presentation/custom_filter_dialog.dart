import 'package:bookstore_app/features/search/view/search/search_cubit.dart';
import 'package:flutter/material.dart';

class FilterDialog extends StatefulWidget {
  const FilterDialog({required this.searchCubit, super.key});

  final SearchCubit searchCubit;

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  late String selectedCategory;
  late double selectedPrice;
  late TextEditingController priceController;
  bool useSlider = true;
  
  final List<String> categories = [
    'All',
    'Fiction',
    'Science',
    'History'
  ];

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.searchCubit.selectedCategory ?? 'All';
    selectedPrice = widget.searchCubit.filteredPrice ?? 600;
    priceController = TextEditingController(text: selectedPrice.toInt().toString());
  }

  @override
  void dispose() {
    priceController.dispose();
    super.dispose();
  }

  void _updatePriceFromSlider(double value) {
    setState(() {
      selectedPrice = value;
      priceController.text = value.toInt().toString();
    });
  }

  void _updatePriceFromTextField(String value) {
    final parsedValue = double.tryParse(value);
    if (parsedValue != null && parsedValue >= 0 && parsedValue <= 10000) {
      setState(() {
        selectedPrice = parsedValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.filter_list, size: 24),
          SizedBox(width: 8),
          Text('Filter Books'),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Filter Section
            // const Text(
            //   'Category',
            //   style: TextStyle(
            //     fontSize: 16,
            //     fontWeight: FontWeight.w600,
            //   ),
            // ),
            // const SizedBox(height: 8),
            // Container(
            //   width: double.infinity,
            //   padding: const EdgeInsets.symmetric(horizontal: 12),
            //   decoration: BoxDecoration(
            //     border: Border.all(color: Colors.grey.shade300),
            //     borderRadius: BorderRadius.circular(8),
            //   ),
            //   child: DropdownButtonHideUnderline(
            //     child: DropdownButton<String>(
            //       value: selectedCategory,
            //       isExpanded: true,
            //       items: categories.map((category) {
            //         return DropdownMenuItem(
            //           value: category,
            //           child: Text(category),
            //         );
            //       }).toList(),
            //       onChanged: (value) {
            //         setState(() {
            //           selectedCategory = value!;
            //         });
            //       },
            //     ),
            //   ),
            // ),
            
            // const SizedBox(height: 24),
            
            // Price Filter Section
            const Text(
              'Maximum Price',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            
            // Price input toggle
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Radio<bool>(
                        value: true,
                        groupValue: useSlider,
                        onChanged: (value) {
                          setState(() {
                            useSlider = value!;
                          });
                        },
                      ),
                      const Text('Slider'),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Radio<bool>(
                        value: false,
                        groupValue: useSlider,
                        onChanged: (value) {
                          setState(() {
                            useSlider = value!;
                          });
                        },
                      ),
                      const Text('Type'),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Price input section
            if (useSlider) ...[
              // Slider input
              Text(
                'Price: \$${selectedPrice.toInt()}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Slider(
                min: 0,
                max: 10000,
                value: selectedPrice,
                divisions: 100,
                label: '\$${selectedPrice.toInt()}',
                onChanged: _updatePriceFromSlider,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('\$0', style: TextStyle(color: Colors.grey.shade600)),
                  Text('\$10,000', style: TextStyle(color: Colors.grey.shade600)),
                ],
              ),
            ] else ...[
              // Text field input
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Enter maximum price',
                  prefixText: '\$',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  helperText: 'Range: \$0 - \$10,000',
                ),
                onChanged: _updatePriceFromTextField,
              ),
            ],
            
            const SizedBox(height: 16),
            
            // Current filters summary
            // Container(
            //   padding: const EdgeInsets.all(12),
            //   decoration: BoxDecoration(
            //     color: Colors.grey.shade50,
            //     borderRadius: BorderRadius.circular(8),
            //     border: Border.all(color: Colors.grey.shade200),
            //   ),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       const Text(
            //         'Current Filters:',
            //         style: TextStyle(
            //           fontWeight: FontWeight.w600,
            //           fontSize: 14,
            //         ),
            //       ),
            //       const SizedBox(height: 4),
            //       Text('Category: $selectedCategory'),
            //       Text('Max Price: \$${selectedPrice.toInt()}'),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            // Reset filters
            setState(() {
              selectedCategory = 'All';
              selectedPrice = 600;
              priceController.text = '600';
            });
          },
          child: const Text('Reset'),
        ),
        ElevatedButton(
          onPressed: () {
            // Apply filters
            widget.searchCubit.setFilterbyPrice(selectedPrice);
            // widget.searchCubit.setFilterByCategory(selectedCategory);
            Navigator.pop(context);
          },
          child: const Text('Apply Filters'),
        ),
      ],
    );
  }
}